plugin.checkDisk = function()
{
	if (plugin.enabled)
		log("Benutzer Speicher : "+theConverter.bytes(plugin.full-plugin.free));
}
plugin.checkDisk();
