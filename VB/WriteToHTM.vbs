Dim FTPUsers()
htmFile = "C:\scripts\users\example.htm"
strMaster = "c:\scripts\master.txt"
k=1
Set ObjFSO = CreateObject("Scripting.FileSystemObject")
Set strHTMFile = ObjFSO.CreateTextFile(htmFile,8)
Set strMasterFile = ObjFSO.OpenTextFile(strMaster, 1)

Do While strMasterFile.AtEndofLine <> True
	ReDim Preserve FTPUsers(k)
	FTPUsers(k) = strMasterFile.ReadLine
	k = k + 1
Loop

Sub WriteToHTMFile
	strHTMFile.writeline "<!DOCTYPE html>"
	strHTMFile.writeline "<html>"
	strHTMFile.writeline "<body>"
	strHTMFile.writeline "<h1>List of FTP Accounts</h1>"
	strHTMFile.writeLine "<table border=" & chr(34) & "1" & chr(34) & ">"
	strHTMFile.writeline "<tr><td>#</td><td><b><font size=" & chr(34) & "4" & chr(34) & " color=" & chr(34) & "red" & chr(34) & ">USERNAME</font></b></td><td><b>"
	strHTMFile.writeLine "<font size=" & chr(34) & "4" & chr(34) & " color=" & chr(34) & "red" & chr(34) & ">PASSWORD</font></b></td></tr>"
	For k = 1 to UBound(FTPUsers)
		a = Split(FTPUsers(k),",")
		strHTMFile.writeLine "<tr><td>" & k & "</td><td>" & a(0) & "</td><td>" & a(1) & "</td></tr>"
	next
	strHTMFile.writeline "<tr><td></td></tr>"
	strHTMFile.writeline "</table>"
	strHTMFile.writeline "</body>"
	strHTMFile.writeline "</html>"
End Sub

WriteToHTMFile
