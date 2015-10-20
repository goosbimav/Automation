Dim txtFile
strComputer = "tmpwebeng01"
Const ForWriting = 2
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.execquery("Select * from Win32_UserAccount")
Set ObjFSO = CreateObject("Scripting.FileSystemObject")
txtFile = "C:\scripts\users.txt"
Set objFile = objFSO.OpenTextFile(txtFile, ForWriting, True)


For Each Object In colItems
	objFile.WriteLine Object.Name & "," & Object.Description & "," & Object.SIDType
Next