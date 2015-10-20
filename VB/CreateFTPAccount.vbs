Dim Users()
Dim k
Dim objFSO
strComputer = "localhost"
'strReadFile = "d:\admin\users.txt"
userPath = "E:\ftp_tmpwebeng_com\clients\"

Const ADS_UF_PASSWD_CANT_CHANGE = "&H0040"
Const ADS_UF_DONT_EXPIRE_PASSWD = "&H10000"
Const ADS_ACETYPE_ACCESS_DENIED_OBJECT = &H6
Const CHANGE_PASSWORD_GUID = "{ab721a53-1e2f-11d0-9819-00aa0040529b}"
Set objFSO = CreateObject("Scripting.FileSystemObject")
'Set objFile = objFSO.OpenTextFile(strReadFile,1)
k = 1
logFile = "C:\scripts\master.txt"

Set strFile = ObjFSO.OpenTextFile(logFile, 8)

Sub LogIt(txtString)
	strFile.writeLine txtString
End Sub

'Passes in text file with username/password separated by comma
'Do While objFile.AtEndofLine <> True
'	ReDim Preserve Users(k)
'	Users(k) = objFile.ReadLine
'	k = k + 1
'Loop

'Loops through each line of text file and separates username and password into
'separatee objects.  Username will create folder in FTP destination while also
'setting folder permissions
Function CreateUser()
	'On Error Resume Next 
'	For k = 1 To UBound(Users)
		Dim Username, Password
		Username = InputBox("Input desired user name")
		Password = randomString
		IntFound = 0
		Set colAccounts = GetObject("WinNT://" & strComputer)
		For Each User In colAccounts
			If LCase(User.Name) = LCase(Username) Then
				intFound = 1
			End If
		Next
		If intFound = 1 Then	
			WScript.Echo "Username: " & Username & " already exists. Checking folder and virtual directory"
			createFTPFolder(UserName)
			setVirtualDir(UserName)
		Else
			Set objUser = colAccounts.Create("user", Username)
			objUser.SetPassword Password
			ObjUser.Description = Password
			objUser.SetInfo
			'Account settings. Password set not to expire, cannot change password
			setNoPassword(UserName)
			disablePasswordChange(UserName)
			objUser.setInfo
			Wscript.echo "User created. Username/Password "
			Wscript.echo "ftp://ftp.tmpwebeng.com"
			wscript.echo "User: " & Username
			Wscript.echo "Password: " & Password
			LogIt(Username & "," & Password)
			createFTPFolder(UserName)
			setVirtualDir(UserName)
		End If 
		Set objUser = Nothing
		Set colAccounts = Nothing
'	Next
End Function

Function setNoPassword(strUser)
	Set newObject = GetObject("WinNT://" & strComputer & "/" & strUser)
	objUserFlags = newObject.Get("UserFlags")
	objPasswordExpirationFlag = objUserFlags OR ADS_UF_DONT_EXPIRE_PASSWD
	newObject.Put "userFlags", objPasswordExpirationFlag 
	newObject.SetInfo
	Set newObject = Nothing
End Function

Function disablePasswordChange(strUser)
	Set objUser = GetObject("WinNT://" & strComputer & "/" & strUser)
	If Not objUser.UserFlags And ADS_UF_PASSWD_CANT_CHANGE Then
		objPasswordNoChangeFlag = objUser.UserFlags OR ADS_UF_PASSWD_CANT_CHANGE
	    objUser.Put "userFlags", objPasswordNoChangeFlag 
	    objUser.SetInfo
	End If
End Function

Function createFTPFolder(strUser)
	newFolder = userPath & strUser
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objShell = CreateObject("Wscript.Shell")
	If Not objFSO.FolderExists(newFolder) Then
		objFSO.CreateFolder(newFolder)
		WScript.Echo newFolder & ": new folder created"
		intRunError = objShell.Run("%COMSPEC% /c Echo Y| cacls """ & newFolder & """ /e /c /g " & strUser & ":F ")
		If intRunError <> 0 Then
			WScript.Echo "Error assigning user permissions to folder"
		End If 
	Else
		WScript.Echo "Folder exists"
		intRunError = objShell.Run("%COMSPEC% /c Echo Y| cacls """ & newFolder & """ /e /c /g " & strUser & ":F ")
	End if
End Function

Function setVirtualDir(strUser)
	Set FTPSVC = GetObject("IIS://localhost/MSFTPSVC/1987499636/ROOT")
	Set virDir = FTPSVC.Create("IIsFTPVirtualDir", strUser)
	virDir.Path = userPath & strUser
	virDir.AccessFlags = 3
	virDir.SetInfo
End Function

Function FindElement(collection, elementTagName, valuesToMatch)
   For i = 0 To CInt(collection.Count) - 1
      Set element = collection.Item(i)
      If element.Name = elementTagName Then
         matches = True
         For iVal = 0 To UBound(valuesToMatch) Step 2
            Set property = element.GetPropertyByName(valuesToMatch(iVal))
            value = property.Value
            If Not IsNull(value) Then
               value = CStr(value)
            End If
            If Not value = CStr(valuesToMatch(iVal + 1)) Then
               matches = False
               Exit For
            End If
         Next
         If matches Then
            Exit For
         End If
      End If
   Next
   If matches Then
      FindElement = i
   Else
      FindElement = -1
   End If
End Function

function RandomString( )
    Randomize( )
    dim CharacterSetArray
    CharacterSetArray = Array( _
      Array( 7, "abcdefghijklmnopqrstuvwxyz" ), _
      Array( 1, "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ), _
      Array( 1, "0123456789" ), _
      Array( 1, "!@#$+-*&?:" ) _
    )
    dim i
    dim j
    dim Count
    dim Chars
    dim Index
    dim Temp

    for i = 0 to UBound( CharacterSetArray )
      Count = CharacterSetArray( i )( 0 )
      Chars = CharacterSetArray( i )( 1 )
      for j = 1 to Count
        Index = Int( Rnd( ) * Len( Chars ) ) + 1
        Temp = Temp & Mid( Chars, Index, 1 )
      next
    next
    dim TempCopy

    do until Len( Temp ) = 0
      Index = Int( Rnd( ) * Len( Temp ) ) + 1
      TempCopy = TempCopy & Mid( Temp, Index, 1 )
      Temp = Mid( Temp, 1, Index - 1 ) & Mid( Temp, Index + 1 )
    loop
    RandomString = TempCopy
 end function
'Main
CreateUser