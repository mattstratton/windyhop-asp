<%Option Explicit%><!-- #include file="../include/globalc.inc" --> <!-- #include file="../include/hasrights.inc" --> <%''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' DisplayCalendar(iMonth, iYear) - Displays the caledar with checkboxs for each date'		for a given month/year.'	INPUT:'		iMonth - month value 1-12'		1Year  - year in YYYY' 	    iNumOfDates - what number to start counting on.  allows multi-month pages.'	OUTPUT:'		iNumOfDates - what number is left off on.  allows multi-month pages'	DEPENDENCIES:'		iNumOfDates -- required global variable (global to page, not all of SwingHomeChicago.com). iNumOfDates'			counts the number of date checkboxed generated on the current page.''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Function DisplayCalendar(iMonth, iYear, iNumOfDates)	Dim todayColor 	Dim dayColor   	Dim noColor	Dim bgColor		todayColor = "#daa520"	dayColor   = "#ffe4b5"	noColor    = "white"		Dim font	font = "<font face=""Arial, Verdana, Helvetica"" size=2>"		Dim checkBox	Dim weekdayCounter, dayCounter	Dim currentDate, x	Dim cellData		Const SPACE = "&nbsp;"		cellData = "" 'SPACE		dayCounter = 1		currentDate = iMonth & "/1/" & iYear	Response.Write("<table cellpadding=2 width=300 border=1>")		Response.Write("<tr colspan=7>")	Response.Write("<td align=center colspan=7>")	Response.Write(MonthName(Month(currentDate)) & ", " & Year(currentDate))	Response.Write("</td>")	Response.Write("</tr>")		Response.Write("<tr>")	Response.Write("<th align=center> " & font & "S</td>")	Response.Write("<th align=center> " & font & "M</th>")	Response.Write("<th align=center> " & font & "T</th>")	Response.Write("<th align=center> " & font & "W</th>")	Response.Write("<th align=center> " & font & "T</th>")	Response.Write("<th align=center> " & font & "F</th>")	Response.Write("<th align=center> " & font & "S</th>")	Response.Write("</tr>")			currentDate = iMonth & "/1/" & iYear	'iNumOfDates = 1	Do While Month(currentDate) = iMonth			Response.Write("<tr align=center>")		For weekdayCounter = vbSunday to vbSaturday						bgColor = dayColor						If Weekday(currentDate) = weekdayCounter Then								cellData = Day(currentDate)								checkBox = "<input type=checkbox name=form?" & iNumOfDates & " value=" & currentDate & ">"								'date?" & Year(currentDate) _ 				'									   & "?" & Month(currentDate) _				'									   & "?" & Day(currentDate) & ">"				iNumOfDates = iNumOfDates + 1													   				cellData = cellData & checkBox								currentDate = DateAdd("d", 1, currentDate)  			Else				bgColor = noColor			End If						If currentDate = date Then 				bgcolor = todayColor 							End If						Response.Write("<td bgcolor= " & bgcolor & " align=center>" & font & cellData & "</td>")						If Month(currentDate) <> iMonth Then Exit For						cellData = "" 'SPACE					Next		Response.Write("</tr>")			Loop		Response.Write("</table>")	'Response.Write("j = "&j&"<br>j2 = "&j2&"<br>j3 = "&j3&"<br>")	'Response.Write("<br>")	'Response.Write("<input type=hidden name=datetype value=many>")	DisplayCalendar = iNumOfDatesEnd Function ' DisplayCalendar''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub BuildCalendarForm()		Dim iTempCounter				iTempCounter = 1 		%>		<form method=post action=multievent.asp name=eventform>		<input type=submit action=submit name=action value=submit>		<table><tr><td align=top>		<%				iTempCounter = DisplayCalendar(Month(date),Year(Date), iTempCounter)		%></td><td align=top><%		iTempCounter = DisplayCalendar(Month(DateAdd("m",1,Date)), Year(DateAdd("m",1,Date)), iTempCounter)		%></td><td align=top><%		iTempCounter = DisplayCalendar(Month(DateAdd("m",2,Date)), Year(DateAdd("m",2,Date)), iTempCounter)		%>		</td></tr></table>		<input type=hidden name=iNumOfDates value=<%=iTempCounter%>>		<input type=submit action=multievent name=action value=submit>				</form>			<%End Sub 'BuildCalendarForm()''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Function BuildDateString()		Dim strTemp	Dim x			For x = 1 to Request.Form("iNumOfDates")		strTemp = Request.Form("form?" & x)		If IsDate(strTemp) Then			If BuildDateString > "" Then				BuildDateString = BuildDateString & ", " & strTemp			Else				BuildDateString = strTemp			End If		End If	Next	End Function 'BuildDateString()''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''If HasRights("mulitevent", Session("userlevel")) Then	Response.Redirect("default.asp")	Response.EndEnd IfDim sActionDim dateStringsAction = lcase(Request.Form("action"))Select Case sAction	Case "submit"		dateString = BuildDateString()		Session("dateString") = dateString		Response.Redirect("editevent.asp?action=Edit%20Event&eventtype=Show/DJ")		'Response.Write(dateString)	Case Else		BuildCalendarForm()End Select%>