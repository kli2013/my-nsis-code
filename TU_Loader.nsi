!define APP "Total Uninstall"

SetCompressor /SOLID lzma
SetCompressorDictSize 32
!include "x64.nsh"
!include TextFunc.nsh
!insertmacro GetParameters

WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel admin

Name "${APP} set"
OutFile "..\TU_Loader.exe"
Icon "1.ico"

Section "Main"
SetOutPath "$EXEDIR\"
CreateDirectory "$EXEDIR\Data"
ifFileExists "$EXEDIR\Data\Program Options.xml" runprogram 0
System::Call "Kernel32::GetSystemDefaultLangID(v ..) i .s"
Pop $3
intop $3 $3 & 0xffff
StrCmp $3 "2052" 0 +3
StrCpy $4 "Chinese-Simplified"
goto +3
StrCmp $3 "1028" 0 runprogram
StrCpy $4 "Chinese-Traditional"
FileOpen $5 "$EXEDIR\Data\Program Options.xml" a
FileWrite $5 '<?xml version="1.0" encoding="utf-8"?>$\n'
FileWrite $5 "<TotalUninstall><Options><Interface><Language>$4</Language></Interface></Options></TotalUninstall>$\n"
FileClose $5
runprogram:
${GetParameters} $0
${If} ${RunningX64}
${AndIf} ${FileExists} "$EXEDIR\x64\Tu.exe"
ReadINIStr $1 $EXEDIR\x64\Tu.ini "general" "ProgramDataPath"
StrCmp $1 "$EXEDIR\Data" +2 0
WriteINIStr "$EXEDIR\x64\Tu.ini" "general" "ProgramDataPath" "$EXEDIR\Data"
Exec `"$EXEDIR\x64\tu.exe" $0`
${Else}
ReadINIStr $1 $EXEDIR\x86\Tu.ini "general" "ProgramDataPath"
StrCmp $1 "$EXEDIR\Data" +2 0
WriteINIStr "$EXEDIR\x86\Tu.ini" "general" "ProgramDataPath" "$EXEDIR\Data"
Exec `"$EXEDIR\x86\tu.exe" $0`
${EndIf}
SectionEnd
