SetCompressor /SOLID lzma
SetCompressorDictSize 32

!include "x64.nsh"
!include TextFunc.nsh
!insertmacro GetParameters

WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user

Name "右键关联"
OutFile "..\右键关联.exe"
Icon "1.ico"

Section "Main"
${If} ${FileExists} "$EXEDIR\AkelPad_loader.exe"
	WriteRegStr   HKLM "SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\batfile\shell\edit\command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\cfgfile\DefaultIcon" "" "$EXEDIR\AkelPad_Loader.exe"
	WriteRegStr   HKLM "SOFTWARE\Classes\cfgfile\Shell\Open\Command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\cmdfile\shell\edit\command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\CSSfile\Shell\Open\Command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\htmlfile\shell\Edit\Command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\inffile\shell\open\command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\inifile\shell\open\command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\luafile\DefaultIcon" "" "$EXEDIR\AkelPad_Loader.exe"
	WriteRegStr   HKLM "SOFTWARE\Classes\luafile\Shell\Open\Command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\regfile\shell\edit\command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\tocfile\DefaultIcon" "" "$EXEDIR\AkelPad_Loader.exe"
	WriteRegStr   HKLM "SOFTWARE\Classes\tocfile\Shell\Open\Command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\txtfile\shell\open" "Icon" "$EXEDIR\AkelPad_Loader.exe,0"
	WriteRegStr   HKLM "SOFTWARE\Classes\txtfile\shell\open\command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\xmlfile\shell\Edit\Command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	WriteRegStr   HKLM "SOFTWARE\Classes\xmlfile\shell\Open\command" "" '"$EXEDIR\AkelPad_Loader.exe" "%1"'
	MessageBox MB_OK|MB_ICONINFORMATION `关联部分文本文件到AkelPad_loader.exe`
${Else}
	MessageBox MB_OK|MB_ICONINFORMATION `没有找到AkelPad_loader.exe，请把本程序放到AkelPad_loader.exe当前目录`
${EndIf}
SectionEnd
