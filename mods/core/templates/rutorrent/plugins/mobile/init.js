/*** Configurable Options ***/
plugin.enableAutodetect = true;
plugin.tabletsDetect = true;
plugin.eraseWithDataDefault = false;
plugin.sort = '-addtime'; /* 'name', 'size', 'uploaded', 'downloaded', 'done', 'eta', 'ul', 'dl', 'ratio', 'addtime', 'seedingtime'. Add preceding negative for descending sort. */
/*** End Configurable Options ***/

plugin.statusFilter = {downloading: 1, completed: 2, label: 4, all: 3, tracker: 5, active: 6, inactive: 7, error: 8};
plugin.navFilter = undefined;
plugin.torrents = null;
plugin.torrentsPrev = null;
plugin.labels = null;
plugin.torrent = undefined;
plugin.lastHref = "";
plugin.currFilter = plugin.statusFilter.all;
plugin.labelInEdit = false;
plugin.eraseWithDataLoaded = false;
plugin.ratioGroupsLoaded = false;
plugin.throttleLoaded = false;
plugin.seedingtimeLoaded = false;
plugin.getDirLoaded = false;
plugin.bootstrapJS = false;

var pageToHash = {
  'torrentsList': '',
  'torrentDetails': 'details',
  'globalSettings': 'settings',
  'torrentSort': 'sort',
  'addTorrent': 'add',
  'confimTorrentDelete': 'delete',
  'getDirList': 'filesystem'
};

var detailsIdToLangId = {
  'status' : 'Status',
  'done' : 'Done',
  'downloaded' : 'Downloaded',
  'size' : 'Size',
  'timeElapsed' : 'Time_el',
  'remaining' : 'Remaining',
  'eta' : 'ETA',
  'ratio' : 'Ratio',
  'downloadSpeed' : 'Down_speed',
  'wasted' : 'Wasted',
  'uploaded' : 'Uploaded',
  'uploadSpeed' : 'Ul_speed',
  'seeds' : 'Seeds',
  'peers' : 'Peers',
  'label' : 'Label',
  'priority' : 'Priority',
  'trackerStatus' : 'Track_status',
  'created' : 'Created_on',
  'savePath' : 'Save_path',
  'comment' : 'Comment'
};

var peersIdToLangId = {
  'address' : 'Address',
  'client' : 'ClientVersion',
  'flags' : 'Flags',
  'done' : 'Done',
  'downloaded' : 'Downloaded',
  'uploaded' : 'Uploaded',
  'dl' : 'DL',
  'ul' : 'UL',
  'peer_dl' : 'PeerDL',
  'peer_downloaded' : 'PeerDownloaded',
};

if(!$type(theWebUI.getTrackerName))
{
  theWebUI.getTrackerName = function(announce)
  {
    var domain = '';
    if(announce)
    {
      var parts = announce.match(/^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*):?([^:@]*))?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/);
      if(parts && (parts.length>6))
      {
        domain = parts[6];
        if(!domain.match(/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/))
        {
          parts = domain.split(".");
          if(parts.length>2)
          {
            if($.inArray(parts[parts.length-2]+"", ["co", "com", "net", "org"])>=0 ||
            $.inArray(parts[parts.length-1]+"", ["uk"])>=0)
            parts = parts.slice(parts.length-3);
            else
            parts = parts.slice(parts.length-2);
            domain = parts.join(".");
          }
        }
      }
    }
    return(domain);
  }
}

$(document).on('blur', 'input, select, textarea', function() {
  setTimeout(function() {
    $(window).scrollTop($(window).scrollTop()+1);
  }, 0);
});

var isEqual = function (a, b) {
  // Create arrays of property names
  var aProps = Object.getOwnPropertyNames(a);
  var bProps = Object.getOwnPropertyNames(b);

  // If number of properties is different,
  // objects are not equivalent
  if (aProps.length != bProps.length) {
      return false;
  }

  for (var i = 0; i < aProps.length; i++) {
      var propName = aProps[i];

      // Skip checking if these properties are equal
      if (propName == 'free_diskspace') {
        continue;
      }

      // If values of same property are not equal,
      // objects are not equivalent
      if (a[propName] !== b[propName]) {
          return false;
      }
  }

  // If we made it this far, objects
  // are considered equivalent
  return true;
};

plugin.getRatioData = function(id)
{
  var curNo = -1;
  var s = this.torrents[id].ratiogroup;
  var arr = s.match(/rat_(\d{1,2})/);
  if(arr && (arr.length>1)) {
    curNo = arr[1];
  }
  return(curNo);
};

plugin.toogleDisplay = function(s) {
  if (s.css('display') == 'none') {
    s.css('display', '')
  } else{
    s.css('display', 'none');
  }
};

plugin.backListener = function() {
  if (this.lastHref != window.location.href) {
    if (window.location.hash == '#details') {
      if (this.torrent != undefined) {
        this.showDetails(this.torrent.hash);
      }
    } else if (window.location.hash == '#settings') {
      this.showSettings();
    } else if (window.location.hash == '#add') {
      this.addTorrent();
    } else if (window.location.hash == '#sort') {
      this.showSort();
    } else if (window.location.hash == '#delete') {
      if (this.torrent != undefined) {
        this.delete();
      }
    } else {
      this.showList();
    }
  }
};

plugin.request = function(url, func) {
  theWebUI.requestWithTimeout(url, function(d){if (func != undefined) func(d);}, function(){}, function(){});
};

plugin.setHash = function(page) {
  window.location.hash = pageToHash[page];
  this.lastHref = window.location.href;
  window.scrollTo(0,0);
};

plugin.showAlert = function(message,alerttype) {
  $('#alert_placeholder').append('<div id="alertdiv" class="alert alert-dismissible fade in navbar-fixed-top '+ alerttype +'" role="alert"><button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>'+ message +'</div>');
  setTimeout(function() {
    $('#alertdiv').removeClass('in');
    setTimeout(function() {
      $("#alertdiv").remove();
    }, 1500);
  }, 5000);
};

plugin.createiFrame = function() {
  $('#addTorrent').prepend('<iframe id="uploadFrame" name="uploadFrame" style="visibility: hidden; width: 0; height: 0; line-height: 0; font-size: 0; border: 0;"></iframe>')
  $('#uploadFrame').load(function() {
    var d = (this.contentDocument || this.contentWindow.document);

    if(d && (d.location.href != "about:blank")) {
      var matchedRegex = d.body.innerHTML.match(/noty\(".*"\+(.*),"(.*)"/);
      if (matchedRegex != null) {
        var message = '';
        try {message = eval(matchedRegex[1]);} catch(e) { }
        if (message != '') {
          if(matchedRegex[2] == "success") {
            plugin.showAlert(message,"alert-success");
          } else if (matchedRegex[2] == "error") {
            plugin.showAlert(message,"alert-danger");
          }
        }
      }
    }
    $('#uploadFrame').remove();
  });
};

plugin.showPage = function(page) {
  $('.mainContainer').css('display', 'none');
  $('.torrentControl').css('display', 'none');
  $('#' + page).css('display', '');
  this.setHash(page);
};

plugin.showList = function() {
  this.showPage('torrentsList');
};

plugin.filter = function(f, self, l) {
  if ($('#torrentsList').is(':visible')) {
    $('#torrentsLabels').css('width', '');
    $('#torrentsTrackers').css('width', '');
    $('#torrentsLabels > a > span').css('width', '');
    $('#torrentsTrackers > a > span').css('width', '');
  }
  if (f == this.statusFilter.label) {
    $('.torrentBlock').css('display', 'none');
    $('.label' + this.labelIds[l]).css('display', '');
    this.navFilter = l;
    if (l == '')
    l = theUILang.No_label;
    $('#torrentsStatus > a > span').html(theUILang.Status);
    $('#torrentsTrackers > a > span').html(theUILang.Trackers);
    $('#torrentsLabels > a > span').html(l);
    $('#torrentsList ul li').removeClass('active');
    $('#torrentsLabels').addClass('active');
    var totalWidth = $('#torrentsList .nav').width();
    var combinedWidth = $('#torrentsStatus').outerWidth(true) + $('#torrentsTrackers').outerWidth(true) + $('#sort').outerWidth(true) + 1;
    var selfWidth = $('#torrentsLabels').width();
    var selfExcess = $('#torrentsLabels').outerWidth(true) - selfWidth;
    var diffWidth = totalWidth - combinedWidth - selfExcess;
    if (diffWidth < selfWidth && selfWidth > 0 && diffWidth > 0) {
      $('#torrentsLabels').width(diffWidth);
      var spanWidth = $('#torrentsLabels > a').width() - $('#torrentsLabels > a > b').outerWidth(true);
      $('#torrentsLabels > a > span').width(spanWidth);
    }
  } else if (f == this.statusFilter.tracker) {
    $('.torrentBlock').css('display', 'none');
    $('.tracker' + this.trackerIds[l]).css('display', '');
    this.navFilter = l;
    $('#torrentsStatus > a > span').html(theUILang.Status);
    $('#torrentsLabels > a > span').html(theUILang.Labels);
    $('#torrentsTrackers > a > span').html(l);
    $('#torrentsList ul li').removeClass('active');
    $('#torrentsTrackers').addClass('active');
    var totalWidth = $('#torrentsList .nav').width();
    var combinedWidth = $('#torrentsStatus').outerWidth(true) + $('#torrentsLabels').outerWidth(true) + $('#sort').outerWidth(true) + 1;
    var selfWidth = $('#torrentsTrackers').width();
    var selfExcess = $('#torrentsTrackers').outerWidth(true) - selfWidth;
    var diffWidth = totalWidth - combinedWidth - selfExcess;
    if (diffWidth < selfWidth && selfWidth > 0 && diffWidth > 0) {
      $('#torrentsTrackers').width(diffWidth);
      var spanWidth = $('#torrentsTrackers > a').width() - $('#torrentsTrackers > a > b').outerWidth(true);
      $('#torrentsTrackers > a > span').width(spanWidth);
    }
  } else {
    if (f == this.statusFilter.all) {
      $('.statusDownloading').css({display: ''});
      $('.statusCompleted').css({display: ''});
      $('#torrentsStatus > a > span').html(theUILang.All);
    }
    if (f == this.statusFilter.downloading) {
      $('.statusDownloading').css({display: ''});
      $('.statusCompleted').css({display: 'none'});
      $('#torrentsStatus > a > span').html(theUILang.Downloading);
    }
    if (f == this.statusFilter.completed) {
      $('.statusDownloading').css({display: 'none'});
      $('.statusCompleted').css({display: ''});
      $('#torrentsStatus > a > span').html(theUILang.Finished);
    }
    if (f == this.statusFilter.active) {
      $('.stateActive').css({display: ''});
      $('.stateInactive').css({display: 'none'});
      $('#torrentsStatus > a > span').html(theUILang.Active);
    }
    if (f == this.statusFilter.inactive) {
      $('.stateActive').css({display: 'none'});
      $('.stateInactive').css({display: ''});
      $('#torrentsStatus > a > span').html(theUILang.Inactive);
    }
    if (f == this.statusFilter.error) {
      $('.errorNo').css({display: 'none'});
      $('.errorYes').css({display: ''});
      $('#torrentsStatus > a > span').html(theUILang.Error);
    }

    $('#torrentsLabels > a > span').html(theUILang.Labels);
    $('#torrentsTrackers > a > span').html(theUILang.Trackers);
    $('#torrentsList ul li').removeClass('active');
    $('#torrentsStatus').addClass('active');
  }
  this.currFilter = f;
};

plugin.showSettings = function() {
  this.request("?action=gettotal", function(total) {
    $('#dlLimit').html('');
    $('#ulLimit').html('');

    var speeds = theWebUI.settings["webui.speedlistdl"].split(",");

    for (var i = 0; i < speeds.length; i++) {
      var spd = speeds[i] * 1024;
      $('#dlLimit').append('<option' + (spd == total.rateDL ? ' selected' : '') + ' value="' + spd + '">' + theConverter.speed(spd) + '</option>');
    };
    $('#dlLimit').append('<option' + ((total.rateDL <= 0 || total.rateDL >= 327625*1024) ? ' selected' : '') + ' value="' + 327625*1024 + '">' + theUILang.unlimited + '</option>');

    speeds=theWebUI.settings["webui.speedlistul"].split(",");

    for (var i = 0; i < speeds.length; i++) {
      var spd = speeds[i] * 1024;
      $('#ulLimit').append('<option' + (spd == total.rateUL ? ' selected' : '') + ' value="' + spd + '">' + theConverter.speed(spd) + '</option>');
    };
    $('#ulLimit').append('<option' + ((total.rateUL <= 0 || total.rateUL >= 327625*1024) ? ' selected' : '') + ' value="' + 327625*1024 + '">' + theUILang.unlimited + '</option>');

    plugin.showPage('globalSettings');
  });
};

plugin.showSort = function() {
  $('#sortOption option').prop('selected', false);
  $('#sort_asc').prop('checked', false);
  $('#sort_desc').prop('checked', false);
  
  var sort = '';
  if(plugin.sort[0] === "-") {
    sort = plugin.sort.substr(1);
    $('#sort_desc').prop('checked', true);
  } else {
    sort = plugin.sort;
    $('#sort_asc').prop('checked', true);
  }
  
  sortHtml = '<option value="name">' + theUILang.Name + '</option>' +
              '<option value="size">' + theUILang.Size + '</option>' +
              '<option value="uploaded">' + theUILang.Uploaded + '</option>' +
              '<option value="downloaded">' + theUILang.Downloaded + '</option>' +
              '<option value="done">' + theUILang.Done + '</option>' +
              '<option value="eta">' + theUILang.ETA + '</option>' +
              '<option value="ul">' + theUILang.Ul_speed + '</option>' +
              '<option value="dl">' + theUILang.Down_speed + '</option>' +
              '<option value="ratio">' + theUILang.Ratio + '</option>';
  
  if (this.seedingtimeLoaded) {
    sortHtml += '<option value="addtime">' + theUILang.addTime + '</option>' +
                '<option value="seedingtime">' + theUILang.seedingTime + '</option>'
  }
  $('#sortOption').html(sortHtml);
  $('#sortOption option[value=' + sort + ']').prop('selected', true);
  
  plugin.showPage('torrentSort');
};

plugin.setDLLimit = function() {
  theWebUI.setDLRate($('#dlLimit').val());
};

plugin.setULLimit = function() {
  theWebUI.setULRate($('#ulLimit').val());
};

plugin.setSort = function() {
  var sort = $('#sortOption').val();
  if($('#sort_desc').prop('checked')) {
    sort = '-' + sort
  }
  plugin.sort = sort;
  plugin.update(true);
  history.go(-1);
};

plugin.addTorrent = function() {
  this.showPage('addTorrent');
  var used = ($('#dir_edit').outerWidth(true) - $('#dir_edit').width()) + $('#showGetDir').outerWidth(true) + 1;
  $('#dir_edit').width($('#addTorrentFile').outerWidth(true) - used);
};

plugin.fillLabel = function(label) {
  if (this.labelInEdit) {
    return;
  }

  $('#torrentDetails #label td:last').text(label + ' ').append('<button class="btn btn-default btn-sm" type="button" onclick="mobile.editLabel();"><i class="glyphicon glyphicon-edit .icon-black"></i></button>');
};

plugin.fillDetails = function(d) {
  $('#torrentName').text(d.name);

  var percent = d.done / 10.0;
  $('#torrentProgress').removeClass('active');
  if (d.done != 1000) {
    $('#torrentProgress').addClass('active');
  }
  $('#torrentProgress .progress-bar').css('width', percent + '%');
  $('#torrentProgress .progress-bar').text(percent + '% ' + theUILang.of + ' ' + theConverter.bytes(d.size,2));

  $('#torrentDetails #status td:last').text(theWebUI.getStatusIcon(d)[1] + ' ').append('<button class="btn btn-default btn-sm" type="button" onclick="mobile.recheck();"><i class="glyphicon glyphicon-refresh .icon-black"></i></button>');
  $('#torrentPriority option').prop('selected', false);
  $('#torrentPriority option[value=' + d.priority + ']').prop('selected', true);
  if (this.ratioGroupsLoaded) {
    $('#torrentRatioGrp option').prop('selected', false);
    if (d.ratiogroup) {
      $('#torrentRatioGrp option[value=' + d.ratiogroup.replace('rat_','') + ']').prop('selected', true);
    } else {
      $('#torrentRatioGrp option[value=-1]').prop('selected', true);
    }
  }
  if (this.throttleLoaded) {
    $('#torrentChannel option').prop('selected', false);
    if (d.throttle) {
      $('#torrentChannel option[value=' + d.throttle.replace('thr_','') + ']').prop('selected', true);
    } else {
      $('#torrentChannel option[value=-1]').prop('selected', true);
    }
  }
  this.fillLabel(d.label);
  $('#torrentDetails #done td:last').text(percent + '%');
  $('#torrentDetails #downloaded td:last').text(theConverter.bytes(d.downloaded,2));
  $('#torrentDetails #size td:last').text(theConverter.bytes(d.size,2));
  $('#torrentDetails #remaining td:last').text(theConverter.bytes(d.remaining,2));
  $('#torrentDetails #timeElapsed td:last').text(theConverter.time(Math.floor((new Date().getTime()-theWebUI.deltaTime)/1000-iv(d.state_changed)),true));
  $('#torrentDetails #created td:last').text((d.created>3600*24*365) ? theConverter.date(iv(d.created)+theWebUI.deltaTime/1000) : "");
  if (this.seedingtimeLoaded) {
    $('#torrentDetails #seedtime td:last').text((d.seedingtime>3600*24*365) ? theConverter.time(new Date().getTime()/1000-(iv(d.seedingtime)+theWebUI.deltaTime/1000),true) : "");
    $('#torrentDetails #dateAdded td:last').text((d.addtime>3600*24*365) ? theConverter.date(iv(d.addtime)+theWebUI.deltaTime/1000) : "");
  }
  $('#torrentDetails #eta td:last').html((d.eta ==- 1) ? "&#8734;" : theConverter.time(d.eta));
  $('#torrentDetails #ratio td:last').html((d.ratio ==- 1) ? "&#8734;" : theConverter.round(d.ratio/1000,3));
  $('#torrentDetails #downloadSpeed td:last').text(theConverter.speed(d.dl));
  $('#torrentDetails #wasted td:last').text(theConverter.bytes(d.skip_total,2));
  $('#torrentDetails #uploaded td:last').text(theConverter.bytes(d.uploaded,2));
  $('#torrentDetails #uploadSpeed td:last').text(theConverter.speed(d.ul));
  $('#torrentDetails #seeds td:last').text(d.seeds_actual + " " + theUILang.of + " " + d.seeds_all + " " + theUILang.connected);
  $('#torrentDetails #peers td:last').text(d.peers_actual + " " + theUILang.of + " " + d.peers_all + " " + theUILang.connected);
  $('#torrentDetails #savePath td:last').text(d.save_path);
  $('#torrentDetails #comment td:last').text(d.comment);
  $('#torrentDetails #trackerStatus td:last').text(d.msg);
};

plugin.changePriority = function() {
  this.request('?action=dsetprio&v=' + $('#torrentPriority').val() + '&hash=' + this.torrent.hash);
};

plugin.changeRatioGrp = function() {
  this.request('?action=setratio&v=' + $('#torrentRatioGrp').val() + '&hash=' + this.torrent.hash);
};

plugin.changeChannel = function() {
  this.request('?action=setthrottle&v=' + $('#torrentChannel').val() + '&hash=' + this.torrent.hash);
};

plugin.editLabel = function() {
  plugin.labelInEdit = true;
  $('#torrentDetails #label td:last')
  .html('<div class="input-append">' +
  '<input class="form-control" id="labelEdit" type="text" value="' + plugin.torrent.label +'"/>' +
  '<button class="btn btn-default btn-sm"><i class="glyphicon glyphicon-ok icon-black"></i></button></div>');
  $('#labelEdit').focus();
  $('#labelEdit').blur(function() {
    var newLabel = $('#labelEdit').val();
    plugin.labelInEdit = false;
    plugin.fillLabel(newLabel);

    if (plugin.torrent.label != newLabel) {
      plugin.torrent.label = newLabel;
      plugin.torrents[plugin.torrent.hash].label = newLabel;

      plugin.request('?action=setlabel&hash=' + plugin.torrent.hash + '&s=label&v=' + encodeURIComponent(newLabel));
    };
  });
};

plugin.showDetails = function(e) {
  this.torrent = this.torrents[e];
  if (this.torrent == undefined)
  return;

  this.torrent.hash = e;
  var d = this.torrent;

  this.fillDetails(d);

  this.showPage('torrentDetails');
  setTimeout(function() {
    var totalWidth = $('#torrentDetails').width();
    var combinedWidth = $('#detailsDetailsPage #priority td:nth-child(1)').outerWidth(true);
    var tdExcess = $('#detailsDetailsPage #priority td:nth-child(2)').outerWidth(true) - $('#detailsDetailsPage #priority td:nth-child(2)').width();
    var diffWidth = totalWidth - combinedWidth - tdExcess;
    $('#torrentDetails select').css('max-width',diffWidth);
  }, 0);
  $('.torrentControl').css('display', '');
  this.showDetailsInDetails();
};

plugin.showDetailsInDetails = function() {
  $('.detailsPage').css('display', 'none');
  $('#detailsDetailsPage').css('display', '');
  $('#detailsNav li').removeClass('active');
  $('#detailsDetailsTab').addClass('active');
};

plugin.showTrackersInDetails = function() {
  $('.detailsPage').css('display', 'none');
  $('#detailsTrackersPage').css('display', '');
  $('#detailsNav li').removeClass('active');
  $('#detailsTrackers').addClass('active');
  this.loadTrackers();
}

plugin.showFilesInDetails = function() {
  $('.detailsPage').css('display', 'none');
  $('#detailsFilesPage').css('display', '');
  $('#detailsNav li').removeClass('active');
  $('#detailsFiles').addClass('active');
  this.loadFiles();
}

plugin.showPeersInDetails = function() {
  $('.detailsPage').css('display', 'none');
  $('#detailsPeersPage').css('display', '');
  $('#detailsNav li').removeClass('active');
  $('#detailsPeers').addClass('active');
  this.loadPeers();
}

plugin.toogleTrackerInfo = function(s) {
  this.toogleDisplay($(s).parent().find('div'));
}

plugin.loadTrackers = function() {
  if (this.torrent != undefined) {
    var hash = this.torrent.hash;
    this.request('?action=gettrackers&hash=' + hash, function(data) {
      var trackers = data[hash];
      if (hash == mobile.torrent.hash) {
        var trackersHtml = '<div class="panel-group" id="trackersAccordion">';

        for (var i = 0; i < trackers.length; i++) {
          trackersHtml +=
          '<div class="panel panel-default"><div class="panel-heading">' +
          '<a class="accordion-toggle" data-toggle="collapse" data-parent="#trackersAccordion" href="#tracker' + i + '">' +
          trackers[i].name + '</a></div>' +
          '<div id="tracker' + i + '" class="panel-collapse collapse"><div class="panel-body">' +
          '<table class=" table table-striped"><tbody>' +
          '<tr><td>' + theUILang.Type + '</td><td>' + theFormatter.trackerType(trackers[i].type) + '</td></tr>' +
          '<tr><td>' + theUILang.Enabled + '</td><td>' + theFormatter.yesNo(trackers[i].enabled) + '</td></tr>' +
          '<tr><td>' + theUILang.Group + '</td><td>' + trackers[i].group + '</td></tr>' +
          '<tr><td>' + theUILang.Seeds + '</td><td>' + trackers[i].seeds + '</td></tr>' +
          '<tr><td>' + theUILang.Peers + '</td><td>' + trackers[i].peers + '</td></tr>' +
          '<tr><td>' + theUILang.scrapeDownloaded + '</td><td>' + trackers[i].downloaded + '</td></tr>' +
          '<tr><td>' + theUILang.scrapeUpdate + '</td><td>' +
          (trackers[i].last ? theConverter.time($.now() / 1000 - trackers[i].last - theWebUI.deltaTime / 1000, true) : '') +
          '</td></tr>' +
          '<tr><td>' + theUILang.trkInterval + '</td><td>' + theConverter.time(trackers[i].interval) + '</td></tr>' +
          '<tr><td>' + theUILang.trkPrivate + '</td><td>' + theFormatter.yesNo(theWebUI.trkIsPrivate(trackers[i].name)) + '</td></tr>' +
          '</tbody></table></div></div></div>';
        }

        trackersHtml += '</div>';
        $('#detailsTrackersPage').html(trackersHtml);

        if (!plugin.bootstrapJS) {
          $('#trackersAccordion a').click(function() {
            $('#trackersAccordion .in').removeClass('in');
            $(this).parent().parent().find('.panel-body').addClass('in');
            return false;
          });
        }
      }
    });
  }
};

plugin.loadPeers = function() {
  if (this.torrent != undefined) {
    var hash = this.torrent.hash;
    this.request('?action=getpeers&hash=' + hash, function(data) {
      var peers = data;
      var pid = Object.keys(peers);
      if (hash == mobile.torrent.hash) {
        var tableHeight = $(window).height() - $('#mainNavbar').outerHeight(true) - ($('#torrentDetails .nav').outerHeight(true) + $('#torrentDetailsHeader').outerHeight(true) + ($('#torrentDetailsHeader #torrentProgress').outerHeight(true) - $('#torrentDetailsHeader #torrentProgress').outerHeight()));
        $('div.tableFixHead').css("max-height", tableHeight + "px");
        
        var peersHtml = '';

        for (var i = 0; i < pid.length; i++) {
          peersHtml += '<tr>' +
          '<td>' + peers[pid[i]].ip + ':' +  peers[pid[i]].port + '</td>' +
          '<td>' + peers[pid[i]].version + '</td>' +
          '<td>' + peers[pid[i]].flags + '</td>' +
          '<td>' + peers[pid[i]].done + '%</td>' +
          '<td>' + theConverter.bytes(peers[pid[i]].downloaded,2) + '</td>' +
          '<td>' + theConverter.bytes(peers[pid[i]].uploaded,2) + '</td>' +
          '<td>' + theConverter.speed(peers[pid[i]].dl) + '</td>' +
          '<td>' + theConverter.speed(peers[pid[i]].ul) + '</td>' +
          '<td>' + theConverter.speed(peers[pid[i]].peerdl) + '</td>' +
          '<td>' + theConverter.bytes(peers[pid[i]].peerdownloaded,2) + '</td>' +
          '</tr>';
        }

        $('#peersTable tbody').html(peersHtml);
      }
    });
  }
};

plugin.files = undefined;

plugin.getDir = function(p) {
  var path = p.split('/');
  if ((path[0] == '') && (path.length == 1)) {
    path = [];
  }

  var dir = plugin.files;
  var realPath = '';
  for (var i = 0; i < path.length; i++) {
    if (path[i] == '') {
      continue;
    }

    if (dir.container[path[i]] != undefined) {
      dir = dir.container[path[i]];
      realPath += '/' + path[i];
      if (!dir.directory) {
        break;
      }
    } else {
      break;
    }
  }

  realPath = realPath.substr(1);
  return [realPath, dir];
}

plugin.getFilesList = function(s) {
  var ret = '';

  for (var name in s) {
    if (s[name].directory) {
      ret += this.getFilesList(s[name].container);
    } else {
      ret += '&v=' + s[name].id;
    }
  }

  return ret;
}

plugin.drawFiles = function(p) {
  var vars = this.getDir(p);
  var realPath = vars[0];
  var dir = vars[1];

  var filesHtml = '';

  if (!dir.root) {
    var i = realPath.lastIndexOf('/');
    if (i < 0) {
      i = 0;
    }
    var upperDir = realPath.substr(0, i);
    filesHtml += '<a href="javascript://void();" onclick="mobile.drawFiles(\'' + upperDir + '\');">' +
    '<i class="glyphicon glyphicon-folder-open icon-black"></i> ..</a><hr>';
  }

  for (var name in dir.container) {
    filesHtml += '<div>' +
    '<div class="hiddenPath">' + realPath + '/' + name + '</div>' +
    '<button onclick="mobile.toogleDisplay($(this).parent().find(\'.prioritySelect\'));" class="btn btn-default btn-sm pull-right"><i class="glyphicon glyphicon-th-list icon-black"></i></button>'
    if (dir.container[name].directory) {
      filesHtml += '<a href="javascript://void();" onclick="mobile.drawFiles(\'' + realPath + '/' + name + '\');">' +
      '<i class="glyphicon glyphicon-folder-open icon-black"></i>&nbsp;' + name + '</a>';
    } else {
      var idName = 'file' + dir.container[name].id;
      filesHtml += '<a href="javascript://void();" onclick="mobile.toogleDisplay($(\'#' + idName + '\'));">' +
      '<i class="glyphicon glyphicon-file icon-black"></i>&nbsp;' + name + '</a><div style="display:none;" id="' + idName + '">' +
      '<table class="table table-striped"><tbody>' +
      '<tr><td>' + theUILang.Done + '</td><td>' + theConverter.bytes(dir.container[name].done) + '</td></tr>' +
      '<tr><td>' + theUILang.Size + '</td><td>' + theConverter.bytes(dir.container[name].size) + '</td></tr>' +
      '</tbody></table></div>';
    }
    filesHtml += '<select class="prioritySelect" style="display:none;">' +
    '<option disabled ' + ((dir.container[name].priority == -1) ? 'selected' : '') + '></option>' +
    '<option value="2" ' + ((dir.container[name].priority == 2) ? 'selected' : '') + '>' + theUILang.High_priority + '</option>' +
    '<option value="1" ' + ((dir.container[name].priority == 1) ? 'selected' : '') + '>' + theUILang.Normal_priority + '</option>' +
    '<option value="0" ' + ((dir.container[name].priority == 0) ? 'selected' : '') + '>' + theUILang.Dont_download + '</option>' +
    '</select></div><hr/>';

  }

  $('#detailsFilesPage').html(filesHtml);
  $('#detailsFilesPage select').change(function() {
    var newValue = $(this).val();
    if (newValue < 0) {
      return;
    }

    var vars = plugin.getDir($(this).parent().find('.hiddenPath').text());

    var filesList = '';
    if (!vars[1].directory) {
      filesList = vars[1].id;
    } else {
      filesList = plugin.getFilesList(vars[1].container);
    }

    plugin.request('?action=setprio&hash=' + plugin.torrent.hash  + '&v=' +filesList + '&s=' + newValue);
  });
}

plugin.fillDirectoriesPriority = function(p) {
  var priority = -2;
  for (var name in p.container) {
    if (p.container[name].directory) {
      this.fillDirectoriesPriority(p.container[name]);
    }
    if (priority == -2) {
      priority = p.container[name].priority;
    } else if (priority != p.container[name].priority) {
      priority = -1;
    }
  }
  p.priority = priority;
}

plugin.loadFiles = function() {
  if (this.torrent != undefined) {
    var hash = this.torrent.hash;
    $('#detailsFilesPage').html('');
    this.request('?action=getfiles&hash=' + hash, function(data) {
      var rawFiles = data[hash];
      var files = {root: true, directory: true, priority: -1, container: {}};

      for (var i = 0; i < rawFiles.length; i++) {
        var path = rawFiles[i].name.replace(/^\/|\/$/g, '').split('/');
        var currDir = files;
        for (var j = 0; j < path.length -1; j++) {
          if (currDir.container[path[j]] == undefined) {
            currDir.container[path[j]] = {directory: true, root: false, container: {}, priority: -2};
          }
          currDir = currDir.container[path[j]];
        }
        currDir.container[path[path.length - 1]] = {root: false,
          directory: false,
          size: rawFiles[i].size,
          done: rawFiles[i].done,
          priority: rawFiles[i].priority,
          id: i
        };
      }

      plugin.fillDirectoriesPriority(files);
      mobile.files = files;
      mobile.drawFiles('');
    });
  }
}

plugin.start = function() {
  if (this.torrent != undefined) {
    var status = this.torrent.state;

    if ((!(status & dStatus.started) || (status & dStatus.paused) && !(status & dStatus.checking) && !(status & dStatus.hashing))) {
      this.request('?action=start&hash=' + this.torrent.hash);
    }
  }
};

plugin.stop = function() {
  if (this.torrent != undefined) {
    var status = this.torrent.state;

    if ((status & dStatus.started) || (status & dStatus.hashing) || (status & dStatus.checking)) {
      this.request('?action=stop&hash=' + this.torrent.hash);
    }
  }
};

plugin.pause = function() {
  if (this.torrent != undefined) {
    var status = this.torrent.state;

    if (((status & dStatus.started) && !(status & dStatus.paused) && !(status & dStatus.checking) && !(status & dStatus.hashing))) {
      this.request('?action=pause&hash=' + this.torrent.hash);
    } else if (((status & dStatus.paused) && !(status & dStatus.checking) && !(status & dStatus.hashing))) {
      this.request('?action=unpause&hash=' + this.torrent.hash);
    }
  }
};

plugin.recheck = function() {
  if (this.torrent != undefined) {
    var status = this.torrent.state;

    if (!(status & dStatus.checking) && !(status & dStatus.hashing)) {
      this.request('?action=recheck&hash=' + this.torrent.hash);
    }
  }
};

plugin.delete = function() {
  if (this.torrent == undefined) {
    this.showList();
  } else {

    if ((this.eraseWithDataLoaded) && (this.eraseWithDataDefault != undefined)) {
      $('#deleteWithData input').prop('checked', this.eraseWithDataDefault);
    }
    if (theWebUI.settings["webui.confirm_when_deleting"]) {
      $('#confimTorrentDelete h5').html('<span id="confirmText">' + theUILang.Rem_torrents_prompt + '</span><hr />' + this.torrent.name);
      this.showPage('confimTorrentDelete');
    } else {
      this.deleteConfimed();
    }
  }
};

plugin.deleteConfimed = function() {
  if ((this.eraseWithDataLoaded) && ($('#deleteWithData input').prop('checked'))) {
    this.request('?action=removewithdata&hash=' + this.torrent.hash);
  } else {
    this.request('?action=remove&hash=' + this.torrent.hash);
  }
  this.torrent = undefined;
  this.showList();
};

plugin.chooseGetDir = function(path) {
  $('#dir_edit').val(path);
  history.go(-1);
}

plugin.drawGetDir = function(path, first) {
  $.ajax({
    url: 'plugins/_getdir/getdirs.php',
    data: {
      'btn': '',
      'edit': '',
      'frame_id': '',
      'dir': path,
      'time': ((new Date()).getTime())
    },

    success: function(data) {
      var re = /<td[\s]+code=\'([\S]+?)\'[\s\S]+?>&nbsp;&nbsp;([\s\S]+?)<\/td>/g;
      var match = null;

      var html = '<table class="table table-striped"><tbody>'

      while ((match = re.exec(data)) != null) {
        if (match[2] == '.') {
          html = '<h5>' + decodeURIComponent(match[1]) + '</h5>' +
          '<button class="btn btn-primary" onclick="mobile.chooseGetDir(\'' + decodeURIComponent(match[1]) + '\');">' + theUILang.ok + '</button>' +
          '<button class="btn btn-default" onclick="history.go(-1);">' + theUILang.Cancel + '</button>' +
          html;
        } else {
          html += '<tr onclick="mobile.drawGetDir(\'' + decodeURIComponent(match[1]) + '\');">' +
          '<td><i class="glyphicon glyphicon-folder-open icon-black"></i> ' + match[2] + '</td></tr>';
        }
      }

      html += '</tbody></table>';
      $('#getDirList').html(html);

      if (first === true) {
        mobile.showPage('getDirList');
      }
    }
  });
};

plugin.showGetDir = function() {
  this.drawGetDir('', true);
};

plugin.updateLabelDropdown = function () {
  $('#torrentsLabels ul').css('width', '');
  $('#torrentsList .nav > li > ul a').css('white-space','');
  var totalWidth = $('#torrentsList .nav').width();
  var combinedWidth = $('#torrentsStatus').outerWidth(true);
  var selfWidth = $('#torrentsLabels ul').width();
  var selfExcess = $('#torrentsLabels ul').outerWidth(true) - selfWidth;
  var diffWidth = totalWidth - combinedWidth - selfExcess;
  if (diffWidth < selfWidth && selfWidth > 0 && diffWidth > 0) {
    $('#torrentsLabels ul').width(diffWidth);
    $('#torrentsList .nav > li > ul a').css('white-space','normal');
  }
};

plugin.updateTrackerDropdown = function () {
  $('#torrentsTrackers ul').css('width', '');
  $('#torrentsList .nav > li > ul a').css('white-space','');
  var combinedWidth = $('#torrentsStatus').outerWidth(true) + $('#torrentsLabels').outerWidth(true) + $('#torrentsTrackers').outerWidth(true);
  var selfWidth = $('#torrentsTrackers ul').width();
  var selfExcess = $('#torrentsTrackers ul').outerWidth(true) - selfWidth;
  var diffWidth = combinedWidth - selfExcess;
  if (diffWidth < selfWidth && selfWidth > 0 && diffWidth > 0) {
    $('#torrentsTrackers ul').width(diffWidth);
    $('#torrentsList .nav > li > ul a').css('white-space','normal');
  }
};

plugin.loadRatio = function () {
  var ratio = thePlugins.get("ratio");
  if (ratio.allStuffLoaded) {
    $('#priority').after('<tr id="ratiogrp"><td></td><td><select id="torrentRatioGrp"></select></td></tr>');
    $('#torrentRatioGrp').change(function(){mobile.changeRatioGrp()});
    var ratioHTML = '<option value="-1">' + theUILang.mnuRatioUnlimited + '</option>'
    $.each(theWebUI.ratios, function(i, v) {
      ratioHTML += '<option value="' + i + '">' + v.name + '</option>';
    });
    $('#torrentRatioGrp').html(ratioHTML);
    $('#ratiogrp').children('td:first').text(theUILang.ratio);
    
    rTorrentStub.prototype.setratio = function()
    {
      for(var i=0; i<this.vs.length; i++)
      {
        var wasNo = plugin.getRatioData(this.hashes[i]);
        if(wasNo!=this.vs[i])
        {
          if(wasNo>=0)
          {
            cmd = new rXMLRPCCommand('view.set_not_visible');
            cmd.addParameter("string",this.hashes[i]);
            cmd.addParameter("string","rat_"+wasNo);
            this.commands.push( cmd );
            cmd = new rXMLRPCCommand('d.views.remove');
            cmd.addParameter("string",this.hashes[i]);
            cmd.addParameter("string","rat_"+wasNo);
            this.commands.push( cmd );
          }
          if(this.vs[i]>=0)
          {
            cmd = new rXMLRPCCommand('d.views.push_back_unique');
            cmd.addParameter("string",this.hashes[i]);
            cmd.addParameter("string","rat_"+this.vs[i]);
            this.commands.push( cmd );
            cmd = new rXMLRPCCommand('view.set_visible');
            cmd.addParameter("string",this.hashes[i]);
            cmd.addParameter("string","rat_"+this.vs[i]);
            this.commands.push( cmd );
          }
        }
      }
    }
  } else {
    setTimeout(function(){plugin.loadRatio()}, 1000);
  }
};

plugin.loadThrottle = function () {
  var throttle = thePlugins.get("throttle");
  if (throttle.allStuffLoaded) {
    $('#priority').after('<tr id="throttle"><td></td><td><select id="torrentChannel"></select></td></tr>');
    $('#torrentChannel').change(function(){mobile.changeChannel()});
    var throttleHTML = '<option value="-1">' + theUILang.mnuUnlimited + '</option>';
    $.each(theWebUI.throttles, function(i, v) {
      throttleHTML += '<option value="' + i + '">' + v.name + '</option>';
    });
    $('#torrentChannel').html(throttleHTML);
    $('#throttle').children('td:first').text(theUILang.throttle);
  
    rTorrentStub.prototype.setthrottle = function()
    {
      for(var i=0; i<this.vs.length; i++)
      {
        var status = theWebUI.getStatusIcon(mobile.torrents[this.hashes[i]]);
        var needRestart = (status[1]==theUILang.Seeding) || (status[1]==theUILang.Downloading);
        var name = (this.vs[i]>=0) ? "thr_"+this.vs[i] : "";
        if(needRestart)
        {
          cmd = new rXMLRPCCommand('d.stop');
          cmd.addParameter("string",this.hashes[i]);
          this.commands.push( cmd );
        }
        cmd = new rXMLRPCCommand('d.set_throttle_name');
        cmd.addParameter("string",this.hashes[i]);
        cmd.addParameter("string",name);
        this.commands.push( cmd );
        if(needRestart)
        {
          cmd = new rXMLRPCCommand('d.start');
          cmd.addParameter("string",this.hashes[i]);
          this.commands.push( cmd );
        }
      }
    }
  } else {
    setTimeout(function(){plugin.loadThrottle()}, 1000);
  }
};

plugin.loadSeedingTime = function () {
  var seedingtime = thePlugins.get("seedingtime");
  if (seedingtime.allStuffLoaded) {
    $('#created').after('<tr id="seedtime"><td></td><td></td></tr>');
    $('#created').after('<tr id="dateAdded"><td></td><td></td></tr>');
    $('#dateAdded').children('td:first').text(theUILang.addTime);
    $('#seedtime').children('td:first').text(theUILang.seedingTime);
  } else {
    setTimeout(function(){plugin.loadSeedingTime()}, 1000);
  }
};

plugin.dynamicSort = function (property) {
  var sortOrder = 1;
  if(property[0] === "-") {
    sortOrder = -1;
    property = property.substr(1);
  }
  return function (a,b) {
    if (typeof a[property] == 'string' || a[property] instanceof String) {
      if (parseInt(a[property])) {
        if (parseInt(b[property])) {
          var result = (parseInt(a[property]) < parseInt(b[property])) ? -1 : (parseInt(a[property]) > parseInt(b[property])) ? 1 : 0;
        } else {
          var result = -1;
        }
      } else if (parseInt(b[property])) {
        var result = 1;
      } else {
        var result = (a[property].toLowerCase() < b[property].toLowerCase()) ? -1 : (a[property].toLowerCase() > b[property].toLowerCase()) ? 1 : 0;
      }
    } else {
      var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
    }
    return result * sortOrder;
  }
}

plugin.update = function(singleUpdate) {
  theWebUI.requestWithTimeout("?list=1&getmsg=1",
  function(data) {
    plugin.torrents = data.torrents;
    plugin.labels = data.labels;
    plugin.labelIds = {};
    plugin.trackerIds = {};
    plugin.labelIds[''] = 0;
    var torrentArray = [];
    var trackersCount = {};
    var trackersMap = {};
    var tul = 0;
    var tdl = 0;
    var nextLabelId = 1;
    var nextTrackerId = 1;
    var labelsHtml = '<li><a href="javascript://void();" onclick="mobile.filter(mobile.statusFilter.label, this, \'\');">' + theUILang.No_label + '</a></li>';
    var trackersHtml = '';

    Object.keys(plugin.labels).sort().forEach(function(l) {
      if (plugin.labelIds[l] == undefined) {
        plugin.labelIds[l] = nextLabelId++;
      }

      labelsHtml += '<li><a href="javascript://void();" onclick="mobile.filter(mobile.statusFilter.label, this, \'' + l + '\');">' + l + ' (' + plugin.labels[l] + ')</a></li>';
    });
    $('#torrentsLabels ul').html(labelsHtml);
    if ($('#torrentsLabels ul').is(':visible')) {
      plugin.updateLabelDropdown();
    }

    var listHtml = $('#torrentsList #list table tbody');
    var listHtmlString = '';

    $.each(plugin.torrents, function(n, v){
      v.hash = n;
      torrentArray.push(v);
    });
    torrentArray.sort(plugin.dynamicSort(plugin.sort));

    mobile.request('?action=getalltrackers', function(data) {
      $.each(torrentArray, function(n, v){
        var status = theWebUI.getStatusIcon(v);
        var statusClass = (v.done == 1000) ? 'Completed' : 'Downloading';
        var stateClass = (v.ul || v.dl) ? 'Active' : 'Inactive';
        var errorClass = (v.state & dStatus.error) ? 'Yes' : 'No';
        var percent = v.done / 10;

        tul += iv(v.ul);
        tdl += iv(v.dl);

        if ( ! listHtml.find($('#' + v.hash)).length || singleUpdate) {
          listHtmlString +=
          '<tr id="' + v.hash + '" class="torrentBlock status' + statusClass + ' state' + stateClass + ' error' + errorClass + ' label' + plugin.labelIds[v.label] + '" onclick="mobile.showDetails(this.id);"><td>' +
          '<h5>' + v.name + '</h5>' +
          '<span>' + status[1] + ((v.ul) ? ' ↑' + theConverter.speed(v.ul) : '') + ((v.dl) ? ' ↓' + theConverter.speed(v.dl) : '') + ' | ' + ((status[1] == 'Downloading') ? (theUILang.ETA + ' ' + ((v.eta ==- 1) ? "&#8734;" : theConverter.time(v.eta))) : (theUILang.Ratio + ' ' + ((v.ratio ==- 1) ? "&#8734;" : theConverter.round(v.ratio/1000,3)))) + ((v.msg) ? ' | <i class="text-danger">' + v.msg + '</i>' : '') + '</span>' +
          '<div class="progress' + ((v.done == 1000) ? '' : ' active') + '">' +
          '<div class="progress-bar progress-bar-striped" style="width: ' + percent + '%;">' + percent + '% ' + theUILang.of + ' ' + theConverter.bytes(v.size,2) + '</div>' +
          '</div>' +
          '</td></tr>';
        } else if ( ! isEqual(plugin.torrents[v.hash], plugin.torrentsPrev[v.hash]) ) {
          listHtml.find($('#' + v.hash)).removeClass();
          listHtml.find($('#' + v.hash)).addClass('torrentBlock');
          listHtml.find($('#' + v.hash)).addClass('status' + statusClass);
          listHtml.find($('#' + v.hash)).addClass('state' + stateClass);
          listHtml.find($('#' + v.hash)).addClass('error' + errorClass);
          listHtml.find($('#' + v.hash)).addClass('label' + plugin.labelIds[v.label]);
          listHtml.find($('#' + v.hash + ' span')).html(status[1] + ((v.ul) ? ' ↑' + theConverter.speed(v.ul) : '') + ((v.dl) ? ' ↓' + theConverter.speed(v.dl) : '') + ' | ' + ((status[1] == 'Downloading') ? (theUILang.ETA + ' ' + ((v.eta ==- 1) ? "&#8734;" : theConverter.time(v.eta))) : (theUILang.Ratio + ' ' + ((v.ratio ==- 1) ? "&#8734;" : theConverter.round(v.ratio/1000,3)))) + ((v.msg) ? ' | <i class="text-danger">' + v.msg + '</i>' : ''));
          listHtml.find($('#' + v.hash + ' .progress')).removeClass('active');
          if (v.done != 1000) {
            listHtml.find($('#' + v.hash + ' .progress')).addClass('active');
          }
          listHtml.find($('#' + v.hash + ' .progress-bar')).css('width', percent + '%');
          listHtml.find($('#' + v.hash + ' .progress-bar')).text(percent + '% ' +theUILang.of + ' ' +theConverter.bytes(v.size,2));
        }

        var trackers = data[v.hash];
        var uniqueTrackers = [];
        for (var i = 0; i < trackers.length; i++) {
          var trackerName = theWebUI.getTrackerName(trackers[i].name);
          if (trackerName) {
            if (trackerName in trackersCount) {
              if ($.inArray(trackerName, uniqueTrackers) == -1) {
                trackersCount[trackerName]++;
              }
            } else {
              trackersCount[trackerName] = 1;
            }
            if (plugin.trackerIds[trackerName] == undefined) {
              plugin.trackerIds[trackerName] = nextTrackerId++;
            }
            if ($.inArray(trackerName, uniqueTrackers) == -1) {
              uniqueTrackers.push(trackerName);
            }
          }
        }
        trackersMap[v.hash] = uniqueTrackers;
      });

      Object.keys(trackersCount).sort().forEach(function(t) {
        trackersHtml += '<li><a href="javascript://void();" onclick="mobile.filter(mobile.statusFilter.tracker, this, \'' + t + '\');">' + t + ' (' + trackersCount[t] + ')</a></li>';
      });
      $('#torrentsTrackers ul').html(trackersHtml);
      if ($('#torrentsTrackers ul').is(':visible')) {
        plugin.updateTrackerDropdown();
      }

      $.each(plugin.torrentsPrev, function(n, v){
        if ( ! plugin.torrents[n] ) {
          listHtml.find($('#' + n)).remove();
        }
      });

      if ( listHtmlString ) {
        if (singleUpdate) {
          listHtml.html(listHtmlString);
        } else {
          listHtml.append(listHtmlString);
        }
      }

      $.each(trackersMap, function(id, ns) {
        $.each(ns, function(i, n) {
          $('#'+id).addClass("tracker"+plugin.trackerIds[n]);
        });
      });
      $('#torrentsAll > a').text(theUILang.All + ' (' + $('.torrentBlock').length + ')');
      $('#torrentsDownloading > a').text(theUILang.Downloading + ' (' + $('.statusDownloading').length + ')');
      $('#torrentsCompleted > a').text(theUILang.Finished + ' (' + $('.statusCompleted').length + ')');
      $('#torrentsActive > a').text(theUILang.Active + ' (' + $('.stateActive').length + ')');
      $('#torrentsInactive > a').text(theUILang.Inactive + ' (' + $('.stateInactive').length + ')');
      $('#torrentsError > a').text(theUILang.Error + ' (' + $('.errorYes').length + ')');

      plugin.filter(plugin.currFilter, undefined, plugin.navFilter);

      if (plugin.torrent != undefined) {
        if (plugin.torrents[plugin.torrent.hash] != undefined) {
          plugin.torrent = plugin.torrents[plugin.torrent.hash];
          plugin.fillDetails(plugin.torrent);
          plugin.loadPeers();
        } else {
          plugin.showList();
        }
      }

      $('#upspeed').text(theConverter.speed(tul));
      $('#downspeed').text(theConverter.speed(tdl));
      
      plugin.torrentsPrev = plugin.torrents;
      
      if (!singleUpdate) {
        setTimeout(function() {mobile.update();}, theWebUI.settings['webui.update_interval']);
      }
    });
  },

  function()
  {
    //TODO: Timeout
  },

  function(status,text)
  {
    //TODO: Error
  }
);
};

plugin.disableOthers = function() {
  var start = (window.location.href.indexOf('mobile=1') > 0);

  if ((!start) && this.enableAutodetect) {
    start = jQuery.browser.mobile;
  }

  if (start) {
    dxSTable.prototype.renameColumn = function(no,name) { }

    dxSTable.prototype.Sort = function(e) { }

    dxSTable.prototype.createRow = function(cols, sId, icon, attr) { }

    dxSTable.prototype.addRow = function (cols, sId, icon, attr) { }

    dxSTable.prototype.addRowById = function (ids, sId, icon, attr) { }

    dxSTable.prototype.refreshRows = function( height, fromScroll ) { }

    dxSTable.prototype.getAttr = function (row, attrName) { }
    
    dxSTable.prototype.setAttr = function(row, attr) { }
    
    dxSTable.prototype.setIcon = function(row, icon) { }

    theWebUI.filterByLabel = function() { }

    $.each(thePlugins.list, function(i, v) {
      if (v.name != 'rpc' && v.name != 'httprpc' && v.name != '_getdir' && v.name != 'throttle' && v.name != 'ratio' && v.name != 'erasedata' && v.name != 'seedingtime' && v.name != 'mobile') {
        v.disable();
      }
    });

    plugin.config = theWebUI.config;
    theWebUI.config = function(data)
    {
    	plugin.config.call(this,data);
    	plugin.init();
    }
  } else {
    this.disable();
  }
};

plugin.init = function() {

  this.lastHref = window.location.href;

  setInterval(function() {plugin.backListener();}, 500);

  var jQueryVer = jQuery.fn.jquery.split('.');
  if ((jQueryVer[0] == 1) && (jQueryVer[1] >= 7)) {
    this.bootstrapJS = true;
  } else if (jQueryVer[0] > 1) {
    this.bootstrapJS = true;	//For future =)
  }

  $.ajax({
    type: 'GET',
    url: this.path + 'mobile.html',
    processData: false,

    error: function(XMLHttpRequest, textStatus, errorThrown) {
      //TODO: Error
    },

    success: function(data, textStatus) {
      $('body').html(data);

      $('link[rel=stylesheet]').remove();
      plugin.loadLang();
      plugin.loadCSS('css/bootstrap.min');
      plugin.loadMainCSS();
      $('head').append('<meta name="apple-mobile-web-app-capable" content="yes" />');
      if (plugin.bootstrapJS)
      injectScript(plugin.path+'js/bootstrap.min.js');

      if (!plugin.bootstrapJS) {
        $('#torrentsStatus > a').click(function(){
          var menu = $('#torrentsStatus');

          if (menu.hasClass('open')) {
            menu.removeClass('open');
          } else {
            menu.addClass('open');
          }
        });
        $('#torrentsStatus > ul').click(function() {
          $('#torrentsStatus').removeClass('open');
        });

        $('#torrentsLabels > a').click(function(){
          var menu = $('#torrentsLabels');

          if (menu.hasClass('open')) {
            menu.removeClass('open');
          } else {
            menu.addClass('open');
          }
        });
        $('#torrentsLabels > ul').click(function() {
          $('#torrentsLabels').removeClass('open');
        });

        $('#torrentsTrackers > a').click(function(){
          var menu = $('#torrentsTrackers');

          if (menu.hasClass('open')) {
            menu.removeClass('open');
          } else {
            menu.addClass('open');
          }
        });
        $('#torrentsTrackers > ul').click(function() {
          $('#torrentsTrackers').removeClass('open');
        });
      }
      
      $('#torrentsLabels > a').click(function(){
        plugin.updateLabelDropdown();
      });
      
      $('#torrentsTrackers > a').click(function(){
        plugin.updateTrackerDropdown();
      });

      $('#mainNavbar').addClass('navbar-fixed-bottom');
      $('.nav-tabs').addClass('navbar-fixed-top');

      $('.torrentControl').css('display', 'none');

      $('#dlLimit').change(function(){plugin.setDLLimit();});
      $('#ulLimit').change(function(){plugin.setULLimit();});

      $('input[id=torrent_file]').change(function() {
        $('#torrentFileName').val($(this).val());
      });

      $('#notAddPath').append(' ' + theUILang.Dont_add_tname);
      $('#startStopped').append(' ' + theUILang.Dnt_start_down_auto);
      $('#fastResume').append(' ' + theUILang.doFastResume);
      $('#randomizeHash').append(' ' + theUILang.doRandomizeHash);
      $('#torrentFileSend').text(theUILang.add_button);

      $('#torrentPriority').html(
        '<option value="3">' + theUILang.High_priority + '</option>' +
        '<option value="2">' + theUILang.Normal_priority + '</option>' +
        '<option value="1">' + theUILang.Low_priority + '</option>' +
        '<option value="0">' + theUILang.Dont_download + '</option>'
      );
      $('#torrentPriority').change(function(){mobile.changePriority()});

      var makeAddRequest = function(frm)
      {
        var s = theURLs.AddTorrentURL+"?";
        if($("#torrents_start_stopped").prop("checked")) {
          s += 'torrents_start_stopped=1&';
        }
        if($("#fast_resume").prop("checked")) {
          s += 'fast_resume=1&';
        }
        if($("#not_add_path").prop("checked")) {
          s += 'not_add_path=1&';
        }
        if($("#randomize_hash").prop("checked")) {
          s += 'randomize_hash=1&';
        }
        var dir = $.trim($("#dir_edit").val());
        if(dir.length) {
          s += ('dir_edit='+encodeURIComponent(dir)+'&');
        }
        var lbl = $.trim($("#tadd_label").val());
        if(lbl.length) {
          s += ('label='+encodeURIComponent(lbl));
        }
        frm.action = s;
        return(true);
      }
      $("#addTorrentFile").submit(function()
      {
        if(!$("#torrent_file").val().match(".torrent")) {
          plugin.showAlert(theUILang.Not_torrent_file,"alert-danger");
          return(false);
        }
        plugin.createiFrame();
        return(makeAddRequest(this));
      });
      $("#addTorrentUrl").submit(function() {
        plugin.createiFrame();
        return(makeAddRequest(this));
      });

      if (thePlugins.isInstalled('erasedata')) {
        $('#confimTorrentDelete h5').after(
          '<div class="checkbox"><label" id="deleteWithData">' +
          '<input type="checkbox"> ' + theUILang.Delete_data + '</label></div>');

          plugin.eraseWithDataLoaded = true;
        }
        
        if (thePlugins.isInstalled('throttle')) {
          plugin.throttleLoaded = true;
          plugin.loadThrottle();
        }
        
        if (thePlugins.isInstalled('ratio')) {
          plugin.ratioGroupsLoaded = true;
          plugin.loadRatio();
        }

        if (thePlugins.isInstalled('_getdir')) {
          plugin.getDirLoaded = true;
          $('#dirEditBlock').append('<input type="button" class="btn btn-default btn-sm" id="showGetDir" type="button" onclick="mobile.showGetDir();" value="..."></input>');
        }
        
        if (thePlugins.isInstalled('seedingtime')) {
          plugin.seedingtimeLoaded = true;
          plugin.loadSeedingTime();
        }
        plugin.update();
      }
  });
};

plugin.onLangLoaded = function() {
  $('#torrentsStatus > a > span').html(theUILang.All);
  $('#torrentsLabels > a > span').html(theUILang.Labels);
  $('#torrentsTrackers > a > span').html(theUILang.Trackers);

  $('#detailsDetailsTab a').text(theUILang.General);
  $('#detailsTrackers a').text(theUILang.Trackers);
  $('#detailsFiles a').text(theUILang.Files);
  $('#detailsPeers a').text(theUILang.Peers);

  $('#torrentDetails table tr').each(function(n, v) {
    $(v).children('td:first').text(theUILang[detailsIdToLangId[v.id]]);
  });

  $('#dlLimit').parent().children('label').children('h5').text(theUILang.Glob_max_downl);
  $('#ulLimit').parent().children('label').children('h5').text(theUILang.Global_max_upl);
  $('#speedLimitsOk').text(theUILang.ok);
  $('#speedLimitsCancel').text(theUILang.Cancel);

  $('#torrentFile').text(theUILang.Torrent_file+':');
  $('#addUrl').text(theUILang.add_url);

  $('#deleteOk').text(theUILang.ok);
  $('#deleteCancel').text(theUILang.Cancel);
  
  $('#sortAsc').append(' ' + theUILang.acs);
  $('#sortDesc').append(' ' + theUILang.decs);
  $('#sortOption').parent().children('label').children('h5').text(theUILang.SortTorrents);
  $('#sortOk').text(theUILang.ok);
  $('#sortCancel').text(theUILang.Cancel);
  
  $('#peersTable th').each(function(n, v) {
    $(v).text(theUILang[peersIdToLangId[v.id]]);
  });
};

/**
* jQuery.browser.mobile (http://detectmobilebrowser.com/)
*
* jQuery.browser.mobile will be true if the browser is a mobile device
*
**/
(function(a){(jQuery.browser=jQuery.browser||{}).mobile=/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))})(navigator.userAgent||navigator.vendor||window.opera);
if ((plugin.tabletsDetect) && (!jQuery.browser.mobile)) {
  (function(a){(jQuery.browser=jQuery.browser||{}).mobile=/android|ipad|playbook|silk/i.test(a)})(navigator.userAgent||navigator.vendor||window.opera);
}

mobile = plugin;
plugin.disableOthers();
