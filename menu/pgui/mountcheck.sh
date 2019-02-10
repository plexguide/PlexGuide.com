<!doctype html>
<html>
<head>
<meta http-equiv="refresh" content="25" />
<meta charset="UTF-8">
<title>PG User Interface</title>
<style type="text/css">
body {
	background-color: #282E39;
	text-align: left;
}
.test {
}
body,td,th {
	color: #FFFFFF;
	font-size: medium;
	font-family: Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif;
}
a:link {
	color: #E8DD06;
}
a:visited {
	color: #E8DD06;
}
</style>
</head>

<body text="#FFFFFF">
<table width="100%" border="0" cellpadding="5" cellspacing="0" background="https://plexguide.com/wikipics/motherboard3.png">
  <tbody>
    <tr>
      <td width="104">&nbsp;</td>
      <td width="876" align="center"><h1><strong style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: xx-large; font-weight: bolder;">PG User Interface (PG UI)<br>
          <span style="font-size: small">Auto-Refreshes Every 25 Seconds</span><br>
      </strong></h1></td>
      <td width="104" align="center"><img src="https://camo.githubusercontent.com/2d9a1f02588a2f0635117ab3e43dca618344c895/68747470733a2f2f706c657867756964652e636f6d2f77696b69706963732f6c6f676f2e706e67" width="75" height="75" alt=""/></td>
    </tr>
  </tbody>
</table>
<br>
<table width="530" align="center" cellpadding="5">
  <tbody>
    <tr>
      <td width="25%" style="text-align: center"><a href="https://plexguide.com/forums"><img src="https://camo.githubusercontent.com/6a9261977df6c815e4c1c0be4131cc243e7f9496/68747470733a2f2f706c657867756964652e636f6d2f77696b69706963732f6c6f676f2d666f72756d732e706e67" alt="" width="160" height="25"/></a></td>
      <td width="25%" style="text-align: center"><a href="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki"><img src="https://camo.githubusercontent.com/b654870b2693e9f82158f87fda567a2d9e4828f8/68747470733a2f2f706c657867756964652e636f6d2f77696b69706963732f6c6f676f2d77696b692e706e67" alt="" width="160" height="25"/></a></td>
      <td width="25%" style="text-align: center"><a href="https://plexguide.com/account/upgrades"><img src="https://camo.githubusercontent.com/fc76dd93918b3e530376731d3bbd86627b339a69/68747470733a2f2f706c657867756964652e636f6d2f77696b69706963732f6c6f676f2d646f6e6174652e706e67" alt="" width="160" height="25"/></a></td>
    </tr>
  </tbody>
</table>
<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td width="90%" height="30" style="color: #FFFFFF; font-family: 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'DejaVu Sans', Verdana, sans-serif; font-weight: bolder; font-size: small; text-align: center;"><span style="font-weight: bolder; font-style: normal;">PG Members Save - USENET Servers:&nbsp;&nbsp;</span><a href="https://www.newshosting.com/partners/?a_aid=5a65169240efd&a_bid=5ecfe99b" target="_blank">[NewsHosting]</a>&nbsp;&nbsp;<a href="https://www.usenetserver.com/partners?a_aid=5a65169240efd&a_bid=5725b6ed" target="_blank">[<span style="">UseNetServer</span>]</a>&nbsp;&nbsp;<a href="https://www.easynews.com/?a_aid=5a65169240efd&a_bid=ef2f9ea1" target="_blank">[EasyNews]</a></td>
    </tr>
  </tbody>
</table>
<table width="100%" cellpadding="10">
  <tbody>
    <tr>
      <td height="100" valign="top"><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tbody>
            <tr>
              <td width="90%" height="30" style="color: #0FA702; font-family: 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'DejaVu Sans', Verdana, sans-serif; font-weight: bolder; font-size: large; text-align: left;">BLITZ LOG (MOVE WILL BE ADDED LATER)</td>
            </tr>
          </tbody>
        </table>
        <table width="100%" height="44" border="1" align="center" cellpadding="5" cellspacing="0">
          <tbody>
            <tr>
              <td colspan="6" bgcolor="#000000" style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium;"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('tac /plexguide/logs/pgblitz.log | sed -e "/PG Blitz Log - Cycle/q"');
echo "<pre>$output</pre>";
?>
              </span></td>
            </tr>
          </tbody>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tbody>
            <tr>
              <td width="90%" height="30" style="color: #E11919; font-family: 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'DejaVu Sans', Verdana, sans-serif; font-weight: bolder; font-size: large; text-align: left;"><br>
                WARNING LOG</td>
            </tr>
          </tbody>
        </table>
        <table width="100%" height="44" border="1" align="center" cellpadding="5" cellspacing="0">
          <tbody>
            <tr>
              <td colspan="6" bgcolor="#000000" style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium;">NONE</td>
            </tr>
          </tbody>
        </table>
        <br>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tbody>
            <tr>
              <td width="100%" height="30" style="color: #E8DD06; font-family: 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'DejaVu Sans', Verdana, sans-serif; font-weight: bolder; font-size: large; text-align: left;">RClone | Mount Checks</td>
            </tr>
          </tbody>
        </table>
        <table width="100%" height="44" border="1" align="center" cellpadding="0" cellspacing="0">
          <tbody>
            <tr>
              <td width="15%" height="21" bgcolor="#000000" style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium;"><strong>&nbsp;&nbsp;Union - RClone</strong></td>
              <td width="18%" height="21" class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif;"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.union');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" height="21" bgcolor="#000000" style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium; "><span style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium;"><strong>&nbsp;&nbsp;GDrive - RClone</strong></span></td>
              <td width="18%" height="21" class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.gdrive');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" height="21" bgcolor="#000000" class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium; font-weight: bold;"><span style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium;"><strong> &nbsp;&nbsp;TDrive - RClone</strong></span></td>
              <td width="18%" height="21" class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.tdrive');
echo "<pre>$output</pre>";
?>
              </span></td>
            </tr>
            <tr>
              <td width="15%" height="21" bgcolor="#000000" style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium;"><strong>&nbsp; Union - Mount</strong></td>
              <td width="18%" height="21" class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif;"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.umount');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" height="21" bgcolor="#000000" style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium; "><span style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium;"><strong>&nbsp;&nbsp;GDrive - Mount</strong></span></td>
              <td width="170" height="21" class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.tmount');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" height="21" bgcolor="#000000" class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium; font-weight: bold;"><span style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium;"><strong>&nbsp;&nbsp;TDrive - Mount</strong></span></td>
              <td width="18%" height="21" class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.tmount');
echo "<pre>$output</pre>";
?>
              </span></td>
            </tr>
          </tbody>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tbody>
            <tr>
              <td width="90%" height="30" style="color: #E8DD06; font-family: 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'DejaVu Sans', Verdana, sans-serif; font-weight: bolder; font-size: large; text-align: left;"><br>
                Basic Information</td>
            </tr>
          </tbody>
        </table>
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
          <tbody>
            <tr>
              <td width="15%" bgcolor="#000000" style="font-size: medium">&nbsp;&nbsp;Edition</td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif;">
                <?php $output = shell_exec('cat /plexguide/pg.transport');
       echo "<pre>$output</pre>" ?>
              </span></td>
              <td width="15%" height="21" bgcolor="#000000" style="font-size: medium">&nbsp;&nbsp;Version</td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.number');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" bgcolor="#000000" style="font-size: medium">&nbsp;&nbsp;ServerID</td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/server.id');
echo "<pre>$output</pre>" ?>
              </span></td>
            </tr>
            <tr>
              <td width="15%" bgcolor="#000000" style="font-size: medium">&nbsp;&nbsp;Traefik</td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif;">
                <?php $output = shell_exec('cat /plexguide/pg.traefik');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" height="21" bgcolor="#000000" style="font-size: medium">&nbsp;&nbsp;PG Shield</td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.number');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" bgcolor="#000000" style="font-size: medium">&nbsp;&nbsp;PortGuard</td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /var/pg.ports');
echo "<pre>$output</pre>";
?>
              </span></td>
            </tr>
            <tr>
              <td width="15%" bgcolor="#000000" style="font-size: medium"><span style="color: #F7F6F6; font-weight: bold; font-size: medium;"><strong>&nbsp;&nbsp;OS</strong></span></td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF;">
                <?php $output = shell_exec('cat /plexguide/pg.os');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" height="21" bgcolor="#000000" style="font-size: medium"><span style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium; "><span style="color: #F7F6F6; font-weight: bold; font-size: medium;"><strong>&nbsp;&nbsp;Ansible</strong></span></span></td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.ansible');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" bgcolor="#000000" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium; font-weight: bold;"><span style="color: #F7F6F6; font-weight: bold; font-size: medium;"><strong> &nbsp;&nbsp;Used Space</strong></span></span></td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.used');
echo "<pre>$output</pre>" ?>
              </span></td>
            </tr>
            <tr>
              <td width="15%" bgcolor="#000000" style="font-size: medium"><span style="color: #F7F6F6; font-weight: bold; font-size: medium;"><strong>&nbsp; PG GCE</strong></span></td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF;">
                <?php $output = shell_exec('cat /plexguide/pg.gce');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" height="21" bgcolor="#000000" style="font-size: medium"><span style="color: #F7F6F6; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-weight: bold; font-size: medium; "><span style="color: #F7F6F6; font-weight: bold; font-size: medium;"><strong>&nbsp;&nbsp;Docker</strong></span></span></td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.docker');
echo "<pre>$output</pre>";
?>
              </span></td>
              <td width="15%" bgcolor="#000000" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium; font-weight: bold;"><span style="color: #F7F6F6; font-weight: bold; font-size: medium;"><strong>&nbsp;&nbsp;Disk Space</strong></span></span></td>
              <td width="18%" height="21" style="font-size: medium"><span class="test" style="color: #FFFFFF; font-family: Segoe, 'Segoe UI', 'DejaVu Sans', 'Trebuchet MS', Verdana, sans-serif; font-size: medium;">
                <?php $output = shell_exec('cat /plexguide/pg.capacity');
echo "<pre>$output</pre>";
?>
              </span></td>
            </tr>
          </tbody>
        </table>
        <br>
        <table width="100%" border="1" cellpadding="0" cellspacing="0">
          <tbody>
            <tr>
              <td height="206"><span style="color: #FFFFFF; font-family: 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'DejaVu Sans', Verdana, sans-serif; font-weight: bolder; font-size: large; text-align: left;">USEFUL NOTES</span><br>
                <ul>
                  <li><a href="https://www.youtube.com/channel/UCe77pMIK5kj6teb1NzCi9pw">PG YouTube Channel</a></li>
                  <li><a href="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Common-Issues">Wiki - Common Issues</a></li>
                </ul>
                <p><span style="color: #FFFFFF; font-family: 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'DejaVu Sans', Verdana, sans-serif; font-weight: bolder; font-size: large; text-align: left;">TIPS</span></p>
                <ol>
                  <li>Running PG on a dedicated server? Ensure to turn port guard on and turn on PG Shield. Failing to do so leaves you open to attacks.</li>
                  <li>Secured portainer? Make sure to visit the container to secure it!                </li>
                  <li>Loving PlexGuide? Become a <a href="https://plexguide.com/account/upgrades">PG Donor or Sponsor</a>!</li>
                </ol>                </td>
            </tr>
          </tbody>
        </table>
        </td>
    </tr>
  </tbody>
</table>
</body>
</html>
