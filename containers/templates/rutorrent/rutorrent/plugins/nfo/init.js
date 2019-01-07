 /*
 * PLUGIN NFO
 *
 * Author: AceP1983 (Most of the code taken from the original nfo plugin by soupnazi
 * and the filemanager plugin by HWK)
 *
 */

plugin.loadLang();
plugin.loadMainCSS();

if(plugin.enabled && plugin.canChangeMenu()) 
{
	theWebUI.nfoViewer = function( hash, no, mode ) 
	{
		theDialogManager.show("dlg_nfo");
		$("#nfo_format option[value='"+mode+"']").attr('selected', 'selected');	
        var cont = $('#nfo_text pre');
        cont.empty();
        cont.text('                     Loading...');
        $("#nfo_file").val(hash+no);

		var AjaxReq = jQuery.ajax({
			type: "GET",
			timeout: theWebUI.settings["webui.reqtimeout"],
			async : true,
			cache: false,
			data: "hash="+ hash +"&no="+ no +"&mode="+ mode,
			url : "plugins/nfo/action.php",
			success: function(data){
				if (data == '') {
					theDialogManager.hide("dlg_nfo");
					askYesNo( theUILang.nfoNotFoundTitle, theUILang.nfoNotFound, "" );
					return;
				}
				cont.html(data);
			}
		});
	}

	plugin.createFileMenu = theWebUI.createFileMenu;
	theWebUI.createFileMenu = function( e, id ) 
	{
		if(plugin.createFileMenu.call(this, e, id)) 
		{
			if(plugin.enabled) 
			{
//				theContextMenu.add([CMENU_SEP]);
//				var fno = null;
				nfoFile = new Object();
				nfoFile.fno = null;
				var table = this.getTable("fls");
				if((table.selCount == 1)  && (theWebUI.dID.length==40))
				{
					var fid = table.getFirstSelected();
					var ext = '';
					var s = table.getRawValue(fid,0);
					var pos = s.lastIndexOf(".");
					if(pos>0)
					{
						ext = s.substring(pos+1);
						s = s.substring(0,pos);
					}
					if(this.settings["webui.fls.view"])
					{
						var arr = fid.split('_f_');
						nfoFile.fno = arr[1];
					}
					else
					if(!this.dirs[this.dID].isDirectory(fid))
						nfoFile.fno = fid.substr(3);
					if(ext.toLowerCase() !== "nfo")
						nfoFile.fno = null;
				}
				theContextMenu.add( [theUILang.nfoView,  (nfoFile.fno==null) ? null : "theWebUI.nfoViewer('" + theWebUI.dID + "',"+nfoFile.fno+","+1+")"] );
			}
			return(true);
		}
		return(false);
	}
}

plugin.onLangLoaded = function ()
{
	if (this.enabled)
	{
		theDialogManager.make( 'dlg_nfo', theUILang.nfoView, ''+
					'<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td width="8%"><strong>Format:</strong></td>'+
					'<td width="92%"><select id="nfo_format" name="nfo_format">'+
						'<option value="1" selected="selected">DOS</option>'+
						'<option value="0">WIN</option>'+
					'</select><input name="nfo_file" type="hidden" id="nfo_file" value="" /></td></tr>'+
					'</table>'+
					'<div id="nfo_text" style="width: 549px;"><pre>Loading...</pre></div>', false);
		$("#nfo_format").change(function() {
			var mode = $(this).val();
			theWebUI.nfoViewer(theWebUI.dID, nfoFile.fno, mode)
		});
	}
}

plugin.onRemove = function()
{
	theDialogManager.hide("dlg_nfo");
}
