<%'	If Not HasRights("viewadminpage", Session("userlevel")) Then'		Response.Redirect("default.asp")'	End If%><!-- #include file="../include/globalc.inc" -->	<!-- #include file="../include/getname.inc" -->	<!-- #include file="../include/top.txt" -->	<!-- #include file="../include/hasrights.inc" -->	<!-- #include file="../include/approvedtext.inc" -->	<h1> Windyhop Administration Page </h1><table border=1><tr><td valign=top>	<h2> Manage Data </h2>	<ul>	<li><a href=approve.asp?action=manage&table=band>Manage Bands<br></a><br>	<li><a href=approve.asp?action=manage&table=venue>Manage Venues <br></a><br>	<li><a href=approve.asp?action=manage&table=instructor>Manage Instructor <br></a><br>	<li><a href=approve.asp?action=ManageNews>Manage News<br></a><br>	<li><a href=approve.asp?action=ManageUsers>Manage Users<br></a><br>	<li><a href=approve.asp?action=ManageEvents>Manage Events<br></a><br>	<li><A HREF="/shc/editphotos.asp?admin=approve">Approve Photos<br></A><br>	<li><A HREF="/shc/editphotos.asp?admin=manage">Manage Photos<br></A><br>	<li><a href = "/shc/editphotos.asp?type=editcat">Edit Categories<br></a><br>	<li><a href = "zootfix.asp">Fix Zoot Scoop<br></a><br>	</ul>	</td>	<td align=top valign=top><h2> Infrastructure </h2><ul><li><a href=http://208.238.102.187:8000>INNERHOST Site Logs<br></a><br><li><a href=/stats/log.html>SHAG Log Analysis<br></a><br><li><a href=promote.asp>Promote Code to Production<br></a><br><li><a href=schedulelinks.asp>Schedule Links<br></a><br><li><a href=windyhopstyle.html>Windyhop Style Guide<br></a><br><li><a href=query.asp>Query the Database<br></a><br>	<%	If HasRights("sendzoot", Session("userlevel")) Then		%>		<li><a href=zoot.asp>Send Out Zoot Scoop<br></a><br>		<%	End If		%>	<li> <a href=contacts.htm>Web Team Contact List</a><br><br><li> <a href=ts.htm>Remote Control</a><br><br>	<%		If HasRights("ftp", Session("userlevel")) Then			%>		<li><a href=ftp://jwyckoff:jason01@staging.windyhop.org>FTP staging.windyhop.org<br></a><br>		<li><a href=ftp://jwyckoff:jason01@www.windyhop.org>FTP production.windyhop.org<br></a><br>		<%	End If		%></ul></td></tr></table><!-- #include file="../include/bottom.txt" -->	