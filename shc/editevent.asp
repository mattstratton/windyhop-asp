<!-- #include file="../include/newtop.txt" --> <!-- #include file="../include/phone_format.inc" --> <!-- #include file="../include/validatestring.inc" --> <!-- #include file="../include/writetablerow.inc" --> <!-- #include file="../include/getname.inc" --> <!-- #include file="../include/getonefield.inc" --> <!-- #include file="../include/libformobjects.inc" --> <!-- #include file="../include/approvedtext.inc" --> <!-- #include file="../include/requiredlegend.inc" --> <!-- #include file="../include/fielddesc.inc" --><!-- #include file="../include/sendmail.inc" --><!-- #include file="../include/hasrights.inc" --><% CONST CURRENT_PAGE = "editevent.asp"Dim jason			Dim sDBNameDim sActionDim sErrorDim localEventID'Dim lngEventidDim strNameDim datDate'Dim lngDay'Dim lngMonth'Dim lngYearDim lngVenueidDim lngBandidDim lngInstructoridDim strLessontimeDim strShowtimeDim strEndtimeDim strPriceDim strAgeDim strNote1Dim strNote2Dim datCreationdateDim strApprovedDim lngUseridDim strNoOfWeeksDim strPreReqDim strDuplicateEventDim bolNationalEventDim strEventTypeDim currentFieldDim localColorDim localHelpDim strSQL'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' GetDecode(eventType, eventFieldName, decodeFieldName) - Gets the value for the decode out ''     of the EventDecode Table.' INPUT - eventType: constants SHOWDJ, LESSON, WORKSHOP, OTHER  '         eventFieldName: which field out of Event are we talking about?'         decodeFieldName: which field in the decode table do we want?' OUTPUT - value of the decode field'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Function GetDecode(eventType, eventFieldName, decodeFieldName)		Dim objDBs	Dim objRSs	Dim tempSQL		Set objDBs = Server.CreateObject("ADODB.Connection")	objDBs.Open DATABASE	tempSQL = "select " & decodeFieldName & " from EventDecode where EventType = '" & eventType & _			  "' AND fieldName = '" & eventFieldName & "'"	'Response.Write(tempSQL)	Set objRSs = objDBs.Execute(tempSQL) '"select name from venue where venueid = 1 ")		'objRSs.Open tempSQL objDBs				Do While Not objRSs.EOF	      GetDecode = objRSs(decodeFieldName)	      objRSs.MoveNext	Loop	objRSs.Close	objDBs.Close	Set objRSs = Nothing	Set objDBs = Nothing	End Function 'GetDecode'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub NotHereNewRecord(recordType)	Response.Write("<small><a href=javascript:popUp('whatsthis.asp?rectype="&recordType&"&term=nothere') alt=huh?> " & recordType & " not here?")	Response.Write("<br>")	Response.Write("<a href=./editrecord.asp?table=" & recordType & ">New " & recordType &"</a>")	End Sub 'NotHereNewRecord(recordType)'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub GetData()	Dim objRS	Dim objDB		Set objDB = Server.CreateObject("ADODB.Connection")	objDB.Open DATABASE	'TODO: Modify the SQL in objDB.Execute to fit your needs...	Set objRS = objDB.Execute("SELECT * FROM Event WHERE EventID = " & localEventID)	If objRS.EOF Then		strName = ""		datDate = ""		lngVenueid = ""		lngBandid = ""		lngInstructorid = ""		strLessontime = ""		strShowtime = ""		strEndtime = ""		strPrice = ""		strAge = ""		strNote1 = ""		strNote2 = ""		datCreationdate = ""		strApproved = ""		If Session("userlevel") = ADMIN Then			lngUserID = ADMINID		Else			lngUserid = Session("userid")		End If				strNoOfWeeks = ""		strPreReq = ""		strPrice = "$"	Else		localEventID = objRS("Eventid")		strName = objRS("Name")		datDate = objRS("Date")		'lngMonth = Month(objRS("Date"))		'lngDay = Day(objRS("Date"))		'lngYear = Year(objRS("Date"))		lngVenueid = objRS("Venueid")		lngBandid = objRS("Bandid")		lngInstructorID = objRS("InstructorID")		'Response.Write(lngInstructorID)		strLessontime = objRS("Lessontime")		strShowtime = objRS("Showtime")		strEndtime = objRS("Endtime")		strPrice = objRS("Price")		strAge = objRS("Age")		strEventType = objRS("EventType")		strNoOfWeeks = objRS("noofweeks")		strPreReq = objRS("prereq")		bolNationalEvent = objRS("National")				strNote1 = objRS("Note1")		strNote2 = objRS("Note2")		datCreationdate = objRS("Creationdate")		strApproved = objRS("Approved")		if strApproved = "" Then			strApproved = NOTAPPROVED		End If		lngUserid = objRS("userid")		'Response.Write(lngUserID)	End IfEnd Sub'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub GetColorAndHelp()	If GetDecode(strEventType, currentField, "Required") = YES Then		localColor = requiredColor	Else		localColor = sRowColor	End If		localHelp = "<small>" & GetDecode(strEventType, currentField, "Help") & "</small>"End Sub'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub DisplayForm()	'Dim sRowColor	'sRowColor="#C4CEE5"	localColor = sRowColor		If strEventType = "" Then		strEventType = Request.QueryString("eventtype")		If strEventType = "" Then			Response.Write("Error accessing page.<br>Error# SHC2342332<br>")			Response.Write("<a href=../default.asp>Return to Home</a>")			Response.End		End If	End If	'Response.Write("<blockquote>")		If localEventID = "" or localEventID = "0" Then		Response.Write("<h1>Create a " & strEventType & "</h1>")		Response.Write("Please create your event and press the Update button<p>")	Else		Response.Write("<h1>Update an Event</h1>")		Response.Write("Please make your changes then press the Update button.<p>")	End If		Response.Write("<font color=red>" & sError & "</font><p>")	Response.Write("<form name=form1 method=Post action=" & CURRENT_PAGE & ">")		RequiredLegend()	Response.Write("<table width=" & TABLEWIDTH & " cellpadding=2 cellspacing=2>")	If strDuplicateEvent = YES Then		Response.Write("<tr bgcolor=" & requiredColor &"><td colspan=2>")				Response.Write("<input type=checkbox name=duplicate value=" & YES & ">")		Response.Write(" Yes, I realize that there is already an event on this date/venue. I know what I'm doing.</td></tr>")	End If					If HasRights("viewids", Session("userlevel")) Then		'EventID		currentField = "EventID"		GetColorAndHelp()		Response.Write("<tr bgcolor=" & localColor &">")		'Response.Write("<td>" &  & "</td>")		Response.Write("<td>Eventid:</td>")		Response.Write("<td><input type=hidden name=localEventID value=" & localEventID & ">" &localEventID& "</td></tr>")	Else		Response.Write("<input type=hidden name=localEventID value=" & localEventID & ">")	End If		'EventType	currentField = "EventType"	GetColorAndHelp()	Response.Write("<tr bgcolor=" & localColor &">")	Response.Write("<td>Event Type:</td>")	Response.Write("<td><input type=hidden name=strEventType value=" & strEventType & ">" & strEventType & "</td></tr>")		'Name	currentField = "Name"	GetColorAndHelp()	%>	<tr bgcolor=<%=localColor%>>	<td>Name:</td>	<td><input size=50 name=strName value="<%=strName%>" maxlength=50></td></tr>	<%	If strEventType = LESSON Then			'Date		currentField = "Date"		GetColorAndHelp()		FieldDesc "Date of 1st Lesson.","If this lesson runs more than one week, what is the FIRST date of the lesson?"		Response.Write("<tr bgcolor=" & localColor &">")		Response.Write("<td>Date of 1st lesson:" & localHelp & "</td>")		Response.Write("<td><input size=20 name=datDate value=" & Chr(34) & datDate & Chr(34) & "></td></tr>")					'#ofWeeks		currentField = "NoOfWeeks"		GetColorAndHelp()		FieldDesc "Number of Weeks.","How many weeks (or number of lessons if not weekly) are there in this class?"		Response.Write("<tr bgcolor=" & localColor &">")		Response.Write("<td>Number of Weeks:" & localHelp & "</td>")		Response.Write("<td><input size=20 name=noofweeks value=" & Chr(34) & strNoOfWeeks & Chr(34) & "></td></tr>")			'Pre REq		currentField = "PreReq"		FieldDesc "Requirements for class.","Should a  participant of this class be at a certain level of dancing ability?"		GetColorAndHelp()		Response.Write("<tr bgcolor=" & localColor &">")		Response.Write("<td>Any Pre-Reqs?:" & localHelp & "</td>")		Response.Write("<td><input size=20 name=prereq value=" & Chr(34) & strPreReq & Chr(34) & "></td></tr>")	Else		'Date				' The following is for multidate events, coming from multievent.asp		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''		If Session("dateString") <> "" Then			datDate = Session("dateString") 			Session("dateString") = ""		End If		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''						currentField = "Date"		GetColorAndHelp()		Response.Write("<tr bgcolor=" & localColor &">")		Response.Write("<td>Date of Event:" & localHelp & "</td>")		Response.Write("<td><input size=50 name=datDate value=" & Chr(34) & datDate & Chr(34) & "></td></tr>")				End If		'VenueID	currentField = "VenueID"	GetColorAndHelp()	FieldDesc "Venue.","Where is this " & strEventType & " taking place?"	Response.Write("<tr bgcolor=" & localColor &">")	Response.Write("<td>Venue:</td>")	Response.Write("<td>")	BuildDropDown "venue", "SELECT VenueID, Name as label from Venue  WHERE approved = '"&APPROVED&"' order by name", lngVenueid	NotHereNewRecord("venue")	Response.Write("</td></tr>")		If strEventType = SHOWDJ Then		'BandID		currentField = "BandID"		GetColorAndHelp()		Response.Write("<tr bgcolor=" & localColor &">")		Response.Write("<td>Band:</td><td>")		BuildDropDown "band", "SELECT BandID, Name as label from Band as BandTable  WHERE approved = '"&APPROVED&"'  order by name", lngBandid		NotHereNewRecord("band")		Response.Write("</td></tr>")	End If		'InstructorID	currentField = "InstructorID"	GetColorAndHelp()	Response.Write("<tr bgcolor=" & localColor &"><td>Instructor:</td><td>")	BuildDropDown "instructor", "SELECT InstructorID, Name as label from Instructor  WHERE approved = '"&APPROVED&"' order by name", lngInstructorid	NotHereNewRecord("instructor")	Response.Write("</td></tr>")	'Lesson Time	currentField = "LessonTime"	GetColorAndHelp()	Response.Write("<tr bgcolor=" & localColor &">")	Response.Write("<td>Lessontime:</td>")	Response.Write("<td><input size=9 name=strLessontime value=" & Chr(34) & strLessontime & Chr(34) & "></td></tr>")	If strEventType = SHOWDJ Then		'ShowTime		currentField = "ShowTime"		GetColorAndHelp()		Response.Write("<tr bgcolor=" & localColor &">")		Response.Write("<td>Showtime:</td>")		Response.Write("<td><input size=9 name=strShowtime value=" & Chr(34) & strShowtime & Chr(34) & "></td></tr>")	End If		'End Time	currentField = "EndTime"	GetColorAndHelp()	Response.Write("<tr bgcolor=" & localColor &">")	Response.Write("<td>Endtime:</td>")	Response.Write("<td><input size=9 name=strEndtime value=" & Chr(34) & strEndtime & Chr(34) & "></td></tr>")	'Price	currentField = "Price"	GetColorAndHelp()	%>	<tr bgcolor="<%=localColor%>">		<td>Price:</td>		<td><input size=20 maxlength=20 name=strPrice value="<%=strPrice%>"></td>	</tr>	<%	'Age	currentField = "Age"	GetColorAndHelp()	Response.Write("<tr bgcolor=" & localColor &">")	Response.Write("<td>Age:</td>")	Response.Write("<td><input size=20 name=strAge value=" & Chr(34) & strAge & Chr(34) & "></td></tr>")		'Note1	currentField = "Note1"	GetColorAndHelp()	Response.Write("<tr bgcolor=" & localColor &">")	Response.Write("<td>Note 1:<br><small>(max " & NOTE_LENGTH & " chararcters)</td><td>")	Response.Write("<textarea name=strNote1 rows=4 cols=40 maxlength=20>" & strNote1 & "</textarea></td></tr>")	'Note2	currentField = "Note2"	GetColorAndHelp()	Response.Write("<tr bgcolor=" & localColor &"><td>Note 2:<br><small>(max " & NOTE_LENGTH & " chararcters)</td><td>")	Response.Write("<textarea name=strNote2 rows=4 cols=40 maxlength=20>" & strNote2 & "</textarea></td></tr>")		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	'Created	currentField = "CreationDate"	GetColorAndHelp()	Response.Write("<tr bgcolor=" & localColor &"><td>Created:</td><td>")	REsponse.Write("<input type=hidden name=datCreationdate value=" & datCreationdate & ">" & datCreationdate & " </td></tr>")		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	'Approved	Response.Write("<tr bgcolor=" & sRowColor &"><td>Approved:</td><td>" & strApproved)	If HasRights("approveevents", Session("userlevel")) Then		Response.Write("<INPUT TYPE=CHECKBOX NAME=approved VALUE=" & APPROVED & " CHECKED >")	Else		Response.Write("<INPUT TYPE=HIDDEN NAME=approved VALUE=" & strApproved & " >")	End If 	Response.Write("</td></tr>")	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	'National Event - Only used for SwingStreet,USA.  	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	If HasRights("nationalevents", Session("userlevel")) Then		Response.Write("<tr bgcolor=" & sRowColor &"><td>National Event:</td><td>" & bolNationalEvent)		If bolNationalEvent Then			Response.Write("<INPUT TYPE=CHECKBOX NAME=national VALUE=" & TRUE & " CHECKED >")		Else			Response.Write("<INPUT TYPE=CHECKBOX NAME=national VALUE=" & TRUE & ">")		End If	Else		Response.Write("<INPUT TYPE=HIDDEN NAME=national VALUE=" & bolNationalEvent & " >")	End If 	Response.Write("</td></tr>")		If HasRights("assignowner", Session("userlevel")) Then		Response.Write("<tr bgcolor=" & sRowColor &"><td>User: </td><td>")		If lngUserID = 0 or Cstr(lngUserID) = "" Then			BuildDropDown "User", "SELECT UserID, Login as label from User order by login", ADMINID		Else			BuildDropDown "User", "SELECT UserID, Login as label from User order by login", lngUserID		End IF		Response.Write("</td></tr>")	ElseIf  HasRights("viewowner", Session("userlevel")) Then		'lngUserID = Session("userid")		Response.Write("<tr bgcolor=" & sRowColor &"><td>User: </td><td>")		Response.Write(GetOneField("select login from user where userid = " & lngUserID, "login"))		Response.Write("<input type=hidden name=userid value = " & lngUserID & " > ")				Response.Write("</td></tr>")	Else		Response.Write("<input type=hidden name=userid value = " & lngUserID & " > ")	End If	Response.Write("</table><p>")	Response.Write("<input type=submit name=action value=Update>")	Response.Write("</form>")	Response.Write("</blockquote>")End Sub'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' CheckDateString(datString)' Returns TRUE/FALSE if it is list of valid dates, seperated by commas'' Assumption: Only enter CheckDateString if it's not a valid date (ie, comma involved)'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Function ValidDateString(datString2)		'jason = "goodbye!"	'Response.Write("<h1>"&jason&"</h1>")			Dim localDate	Dim iStartChar	Dim iEndChar	Dim datString		datString = datString2		'Response.Write("datString = "&datString&"<br>")	iStartChar = 1	'Response.Write("iStartChar = "&iStartChar&"<br>")	iEndChar = InStr(datString, COMMA)	'Response.Write("iEndChar = "&iEndChar&"<br>")		Do		localDate = Mid(datString, iStartChar, iEndChar-1)		'Response.Write("localDate = "&localDate&"<br>")		If Not IsDate(localDate) Then			ValidDateString = FALSE			Exit Function'		Else	'		Response.Write(localDate & " is a valid date! <br>")			End If				iStartChar = iEndChar + 1	'	Response.Write("iStartChar = "&iStartChar&"<br>")				'hack off the date just checked to loop again...		datString = Mid(datString,iStartChar)		'Response.Write("datString = "&datString&"<br>")			iEndChar = InStr(datString, COMMA)	'	Response.Write("iEndChar = "&iEndChar&"<br>")			'temp		iStartchar = 1	Loop While iEndChar > 0		localDate = datString		'Response.Write("localDate = "&localDate&"<br>")	If Not IsDate(localDate) Then			ValidDateString = FALSE			'Response.Write(localDate & " is a BAD BAD BAD date! <br>")			Exit Function		'Else		'	Response.Write(localDate & " is a valid date! <br>")			End If	ValidDateString = TRUEEnd Function 'ValidDateString(datString)'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub ValidateData()	Dim objDB	Dim objRS	Dim temp1	Dim temp2	Dim temp3		Dim iNumOfDates		Set objDB = Server.CreateObject("ADODB.Connection")	objDB.Open DATABASE		localEventID = Request.Form("localEventID")	'localEventID = lngEventid	' Strings don't need to be Validated if it's not going into SQL	strName 		= Request.Form("strName")	datDate 		= Request.Form("datDate")	lngVenueid 		= Request.Form("Venueid")	lngBandid 		= Request.Form("Bandid")	lngInstructorid = Request.Form("Instructorid")	strLessontime   = Request.Form("strLessontime")	strShowtime 	= Request.Form("strShowtime")	strEndtime 		= Request.Form("strEndtime")	strPrice 		= Request.Form("strPrice")	strAge 			= Request.Form("strAge")	strNote1 		= Request.Form("strNote1")	strNote2 		= Request.Form("strNote2")	datCreationdate = Request.Form("datCreationdate")	strApproved 	= Request.Form("Approved")	lngUserid 		= Request.Form("Userid")	strEventType	= Request.Form("strEventType")	strNoOfWeeks	= Request.Form("noofweeks")	strPreReq 		= Request.Form("prereq")	bolNationalEvent = Request.Form("national")		If bolNationalEvent= "" Then		bolNationalEvent = FALSE	End If			If strApproved = "" Then		strApproved = NOTAPPROVED	End If		'BuildDefaultName	'   If the user does not pass a name for the event, build one for them		If strName = "" Then		temp1 = GetName("Band", "Name", lngBandid)		' I use to have the "band_name @ venue_name" to be the default name of the event,		' but since that could not be utilized on the Events page, I changed here. -JDW		'temp2 = GetName("Venue", "Name", lngVenueid)		If temp1 = "" Then			temp1 = "DJ"		End If		strName = temp1 '& " @ " & temp2	End If 	'End BuildDefaultName		If (lngVenueid ="" OR lngVenueID = DEFAULT) Then		sError = sError & "Venueid is a required field.<br>"	End If 	If GetDecode(strEventType, "InstructorID" , "Required") = YES Then		If lngInstructorid = "" or lngInstructorID = DEFAULT Then			sError = sError & "Instructorid is a required field.<br>"		End If 	End If 'GetDecode(strEventType, "Required" , "InstructorID") 		If GetDecode(strEventType, "Showtime",  "Required" ) = YES Then		If strShowtime = "" Then			sError = sError & "Showtime is a required field.<br>"		End If 	End If		If strEventType = LESSON Then		If strNoOfWeeks = "" Then			sError = sError & "Number of Weeks is a required field.<br>"		End If	End If		If strPrice = "$" Then		strPrice = ""	End If 		If GetDecode(strEventType, "Price", "Required") = YES Then		If strPrice = "" Then			sError = sError & "Price is a required field.<br>"		End If 	End If	If datDate <> "" Then		If Not IsDate(datDate) Then	'		jason = "hello!"			Dim temp22			temp22 = ValidDateString(datDate)	'		Response.Write("<h1>"&temp22&"</h1>")	'		Response.Write("<h1>"&jason&"</h1>")'			If temp22 = FALSE Then'				'Response.Write("hdasdfasf")				sError = sError & "The date is not a valid date<br>"			End If		End If 	End If 	If lngUserid = "" Then		sError = sError & "Userid is a required field.<br>Please <a href=mailto:admin@swinghomechicago.com> email </a> the administrators of the error.<br>"	End If 		'If Len(strNote1) > NOTE_LENGTH Then	'	sError = sError & "Note 1 is too long (max " & NOTE_LENGTH & " chars)<br>"	'End If	'If Len(strNote2) > NOTE_LENGTH Then	'	sError = sError & "Note 2 is too long (max " & NOTE_LENGTH & " chars)<br>"	'End If	'CHECKS FOR DUPLICATE EVENT AT SAME PLACE/DATE. COMMENTED OUT FOR MULTI-DATE	'	If Session(strName&datDate&lngVenueID) <> strName then	'		If Request.Form("duplicate") <> YES AND Session(strName&datDate&lngVenueID) <> strName AND LocalEventID = 0 Then	'			'Response.Write("select count(*) as count from event where date = #" & datDate & "# and venueid = " & lngVenueID)	'			temp3 = GetOneField("select count(*) as count from event where date = #" & datDate & "# and venueid = " & lngVenueID, "count")	'			If temp3 > 0 Then	'				sError = sError & "WARNING: An event already exists for that date & venue. If you still want to add " & _	'				"this event, please check the box below."	'				strDuplicateEvent = YES				  	'			End If 'temp3 > 0 	'		End If 'Request.Form("duplicate") <> YES AND Session(strNam...	'	End If 'Session(strName&datDate&lngVenueID) <> strName		If sError <> "" Then		DisplayForm()		Response.End	Else		'If HasRights("approveevents", Session("userlevel")) Then			If CheckForEventApproval(lngBandID, lngVenueID, localEventID, lngInstructorID) = TRUE Then				Response.Write("Thank you.  Your Event was successfully created/updated, and approved automatically because you represent either the band, venue, or instructor chosen. Please view <a href=events.asp>events</a> to confirm.<p> ")				strApproved = APPROVED			Else				Response.Write("Thank you.  Your Event was successfully created, and is awaiting approval from the admins of SwingHomeChicago. <B> YOUR EVENT WILL NOT SHOW UP IN THE CALENDAR UNTIL IT IS APPROVED.</b>")				EmailAdmins()			End If		'ElseIf Session("userlevel") = PRIVUSER Then		'	Response.Write("Thank you.  Your Event was successfully created, and is automatically approved because you are a SUPERUSER.")		'End If			If localEventID = "" or localEventID = "0" Then			'since there is no UniqueRecordID, this must be a new record...			If Session(strName&datDate&lngVenueID) = "" Then				iNumOfDates = 1				Dim tempDate				tempDate = GetDateInString(datDate, iNumOfDates)				'Response.Write("tempDate = " & tempDate & "<br>")				While  tempDate > "" 					CreateNewEvent(tempDate)					iNumOfDates = iNumOfDates + 1					tempDate = GetDateInString(datDate, iNumOfDates)				Wend							End If		Else			Set objRS = Server.CreateObject("ADODB.Recordset")			objRS.open "select * from event where eventid = " & localEventID, _								objDB, adOpenKeyset, adLockOptimistic			objRS("Name") = strName			objRS("Date") = datDate			objRS("Venueid") = lngVenueid			objRS("Bandid") = lngBandid			objRS("Instructorid") = lngInstructorid			objRS("Lessontime") = strLessontime			objRS("Showtime") = strShowtime			objRS("Endtime") = strEndtime			objRS("Price") = strPrice			objRS("Age") = strAge			objRS("Note1") = strNote1 'Left(strNote1, NOTE_LENGTH)			objRS("Note2") = strNote2 'Left(strNote2, NOTE_LENGTH)			objRS("NoOfWeeks") = strNoOfWeeks			'Response.Write("<h1>" & bolNationalEvent & "</h1>")			objRS("National") = bolNationalEvent				objRS("Prereq") = strPreReq			objRS("Approved") = strApproved			objRS("Userid") = lngUserid			objRS("EventType") = strEventType			objRS.Update		End If 'IF localBandID = 0						End If			If Err = 0 Then		ComfirmRecord()	End IfEnd Sub'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub CreateNewEvent(localDate)	Dim objRS	Dim objDB		Set objDB = Server.CreateObject("ADODB.Connection")	objDB.Open DATABASE		Set objRS = Server.CreateObject("ADODB.Recordset")	objRS.open "Event", objDB, adOpenKeyset, adLockOptimistic	objRS.AddNew	objRS("CreationDate") = Date & " " & Time	objRS("Name") = strName	objRS("Date") = localDate	objRS("Venueid") = lngVenueid	objRS("Bandid") = lngBandid	objRS("Instructorid") = lngInstructorid	objRS("Lessontime") = strLessontime	objRS("Showtime") = strShowtime	objRS("Endtime") = strEndtime	objRS("Price") = strPrice	objRS("Age") = strAge	objRS("Note1") = strNote1 'Left(strNote1, NOTE_LENGTH)	objRS("Note2") = strNote2 'Left(strNote2, NOTE_LENGTH)	objRS("NoOfWeeks") = strNoOfWeeks	objRS("Prereq") = strPreReq	objRS("Approved") = strApproved	objRS("Userid") = lngUserid	objRS("EventType") = strEventType	objRS("National") = bolNationalEvent	objRS.Update	Session(strName&datDate&lngVenueID) = objRS("Name")	objRS.Close	objDB.Close	Set objRS = Nothing	Set objDB = Nothing	End Sub 'CreateNewEvent()'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub ComfirmRecord()	Response.Write("<table width=100% >")	Response.Write("The following data was updated successfully:")	WriteTableRow "FIELD", "DATA", HEADING	WriteTableRow "Name:", strName, ""	WriteTableRow "Event Type:", strEventType, ""	WriteTableRow "Date:", datDate, ""	If strEventType = LESSON Then		WriteTableRow "# of Weeks:", strNoOfWeeks, ""		WriteTableRow "Pre Req:", strPreReq, ""	End If			WriteTableRow "Venue:", GetName("Venue", "Name", lngVenueid), ""	If lngBandID > 0 Then		WriteTableRow "Band:",  GetName("Band", "Name", lngBandid), ""	End If	WriteTableRow "Instructor:", GetName("Instructor", "Name", lngInstructorid), ""	WriteTableRow "Lesson Time:", strLessontime, ""	WriteTableRow "Show Time:", strShowtime, ""	WriteTableRow "End Time:", strEndtime, ""	WriteTableRow "Price:", strPrice, ""	WriteTableRow "Age:", strAge, ""	WriteTableRow "Note 1:", strNote1, ""	WriteTableRow "Note 2:", strNote2, ""	WriteTableRow "UserID:", GetName("User", "login", lngUserid) , ""	WriteTableRow "Approved:", ApprovedText(strApproved) , ""	If HasRights("nationalevents", Session("userlevel")) Then		WriteTableRow "National Event:", bolNationalEvent , ""	End If	%>	</table>	<p>	<hr>	<table width=100%>	<tr>		<td align=center colspan=3>		What do you want to do?		</td>	</tr>	<tr>		<td align=center><a href=edit.asp>Return to Edit Page</a></td>		<% If localEventID <> 0 Then			%>			<td align=center><a href=events.asp?style=detail&eventid=<%=localEventID%>>View this event detail</a></td>			<%		End If		%>		<td align=center><a href=<%=CURRENT_PAGE%>?action=Edit%20Event&eventtype=<%=strEventType%>> Add a new <%=strEventType%></a></td>	</tr>	</table>	<%	Response.EndEnd Sub'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' Returns a date in a given string between commas.  ' Returns "" if there is no date at that position'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Function GetDateInString(dateString, datePosition)	Dim localDate	Dim iStartChar	Dim iEndChar		Dim iCounter	iStartChar = 1	For iCounter = 1 to datePosition-1		'Response.Write("hello<br>")		iStartChar = InStr(iStartChar,dateString,COMMA)		If iStartChar > 0 Then			iStartChar = iStartChar + 1		Else			GetDateInString = ""			Exit Function		End If	Next	iEndChar = InStr(iStartChar,dateString,COMMA)	If iEndChar = 0 Then		GetDateInString = Mid(dateString,iStartChar)	Else		GetDateInString = Mid(dateString, iStartChar, iEndChar-iStartChar)	End If	End Function 'GetDateInString'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Function CheckForEventApproval(astrBandID, astrVenueID, astrEventID, astrInstructorID)	If astrBandID = "" Then		astrBandID = 0	End If		If astrVenueID = "" Then		astrVenueID = 0	End If	If astrEventID = "" Then		astrEventID = 0	End If	If astrInstructorID = "" Then		astrInstructorID = 0	End If				Dim bandSQL	Dim venueSQL	Dim eventSQL	Dim instructorSQL	Dim objDB3	Dim objRS3		CheckForEventApproval = FALSE		'If HasRights("approveevents", Session("userlevel")) Then	'	CheckForEventApproval = TRUE	'	Exit Function	'End If		bandSQL=	" SELECT count(*) as count " & _				" FROM   Band " & _				" WHERE  Bandid = " & astrBandID & _				" AND    userid = " & Session("userid")		venueSQL=	" SELECT count(*) as count " & _				" FROM   venue " & _				" WHERE  venueid = " & astrVenueID & _				" AND    userid = " & Session("userid")	eventSQL=	" SELECT count(*) as count " & _				" FROM   Band " & _				" WHERE  Bandid = " & astrBandID & _				" AND    userid = " & Session("userid")		instructorSQL=	" SELECT count(*) as count " & _				" FROM   Instructor " & _				" WHERE  InstructorID = " & astrInstructorID & _				" AND    userid = " & Session("userid")		Set objDB3 = Server.CreateObject("ADODB.Connection")	objDB3.Open DATABASE	Set objRS3 = objDB3.Execute (bandSQL)		If objRS3("count") > 0 Then		CheckForEventApproval = TRUE		objRS3.Close		objDB3.Close		Exit Function	End If	objRS3.Close	Set objRS3 = objDB3.Execute (venueSQL)		If objRS3("count") > 0 Then		CheckForEventApproval = TRUE		objRS3.Close		objDB3.Close		Exit Function	End If	objRS3.Close	'Response.Write(instructorSQL)	Set objRS3 = objDB3.Execute (instructorSQL)		If objRS3("count") > 0 Then		CheckForEventApproval = TRUE		objRS3.Close		objDB3.Close		Exit Function	End If	objRS3.Close	objDB3.Close				 	End Function 'CheckForEventApproval()'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Function DisplayEventOptions()	Response.Write("<h1>New Event</h1>")	Response.Write("<h3>Choose the type of event you would like to create: </h3>")	Response.Write("<table cellpadding=2 border=0>")	Response.Write("<tr>")	Response.Write("<td><a href=" & CURRENT_PAGE & "?action=Edit%20Event&eventtype=" & SHOWDJ & ">" & SHOWDJ & "</a></td>")	Response.Write("<td>The event is a musical gig with a band or DJ as the main attraction.</td>")	Response.Write("</tr><tr>")	Response.Write("<td><a href=" & CURRENT_PAGE & "?action=Edit%20Event&eventtype=" & LESSON & ">" & LESSON & "</a></td>")		Response.Write("<td>The event is a set of dance lessons, usually spanning more than one week</td>")	Response.Write("</tr><tr>")	Response.Write("<td><a href=" & CURRENT_PAGE & "?action=Edit%20Event&eventtype=" & WORKSHOP & ">" & WORKSHOP & "</a></td>")	Response.Write("<td>The event is a one-day workshop of dance instruction. If the workshop spans " & _	    		   " more than one day, multiple events are required.</td>")	Response.Write("</tr><tr>")	Response.Write("<td><a href=" & CURRENT_PAGE & "?action=Edit%20Event&eventtype=" & OTHER & ">" & OTHER & "</a></td>")	Response.Write("<td>Any thing else we didn't cover.</td>")	If HasRights("multievent", Session("userlevel")) Then		Response.Write("</tr><tr>")		Response.Write("<td><a href=multievent.asp> Reoccuring Show/DJ</a></td>")		Response.Write("<td><B>ADMIN & SUPERUSER ONLY.</b> Allows to select from calendar.</td>")	End If	Response.Write("</tr>")	Response.Write("</table>")	End Function'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub EmailAdmins()	Dim strBody	Dim objRSb	Dim objDBb		Set objDBb = Server.CreateObject("ADODB.Connection")	objDBb.Open DATABASE		'Set objRSb = Server.CreateObject("ADODB.Recordset")	'objRSb.open "select * from user where userid = " & lngUserID	Set objRSb = objDBb.Execute("select * from user where userid = " & lngUserID)			strBody = objRSb("FirstName") & " " & objRSb("LastName") & "(" & objRSb("login") & ")" & _			  " just added " & strName & " on " & datDate & "." & _			  " Go to <a href=""http://www.windyhop.org/redirect.asp?page=http://www.windyhop.org/admin/admin.asp""> " & _			  " Admin Page </a> to approve."	Set objDBb = Nothing	Set objRSb = Nothing		SendMail "SwingBot", "swingbot@windyhop.org", "admin@windyhop.org" ,"New Event to Approve: " & strName & "(" & datDate & ")", strBodyEnd Sub'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub CheckForEventDuplicate()End Sub'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''If Session("login") = "" Then	Response.Redirect("edit.asp")End IfIf Request.Form("EventID") = DEFAULT Then	Response.Redirect("edit.asp")End IfsAction = Request("action")If sAction = "" Then	sAction = Request.Querystring("action")End IflocalEventID = Request.Form("EventID")If localEventID = "" Then	localEventID = Request.QueryString("EventID")	If localEventID = "" Then		localEventID = 0	End IfEnd IfIf Request.Form("action") = "Delete Event" Then	Response.Redirect("delete.asp?action=request&table=event&recordid=" & localEventID)End If%> <!-- #include file="../include/top.txt" --> <% 'Response.Write("Session ID = " & Session("userid") & "<br>") If sAction = "Edit Event" Then	GetData()	'Response.Write("local = " & lngUserID & "<br>")	'If Not lngUserID > 0 Then	'	lngUserID = CInt(Session("userid"))	'End If	DisplayForm()ElseIf sAction = "Copy Event" Then	' This COPY EVENT is if someone wants to use an event as a "template" for others	GetData()	localEventID = 0	datDate = ""	strApproved = NOTAPPROVED	DisplayForm()ElseIf sAction = "Update" Then	ValidateData()ElseIf sAction = "New" Then	DisplayEventOptions()Else	'response.Write("hello!!!!!!")	strPrice = "$"	GetData()	DisplayForm()End If%><!-- #include file="../include/newbottom.txt" --> 