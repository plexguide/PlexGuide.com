//
// ruTorrent Torrent-Addition Auto-Labels
// Version 0.8 
// by thezwallrus
//

//
// jquery replace
//

$("#tadd_label").wrap('<div id="taddl_cont" />').remove();
$("#taddl_cont").append('<select id="tadd_label" name="tadd_label"></select>'+
			'<input type="text" id="newLabel" value="New Label..." style="width:100px;"/>'+
			'<input type="button" id="add_newLabel" value="+" class="Button" style="width:30px;" />');

var addLab = $('#add_newLabel');
addLab.click( function() { setTimeout( function() { $('#tadd_label')
						.append($('<OPTION></OPTION>')
						.val( $('#newLabel').val() )
						.text( $('#newLabel').val() )
						.attr('selected','selected') ) }, 300 ) } );

//
// load labels into dropdown
//

theWebUI.initLabelDirs = function()
{
		setTimeout( function() {
			jQuery.each(theWebUI.cLabels, function(lbl, nothing) {
				$('#tadd_label').append($('<OPTION></OPTION>').val(lbl).html(lbl));
			})
		}, 3000 );
	        plugin.markLoaded();
};

theWebUI.initLabelDirs();
