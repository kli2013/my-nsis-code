!define APP "Total Uninstall"

!include "x64.nsh"
!include TextFunc.nsh
!insertmacro GetParameters
!include "TextReplace.nsh"
Var found

WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel admin
SetCompressor /SOLID lzma
SetCompressorDictSize 32

Name "${APP} set"
OutFile "..\TU_Loader.exe"
Icon "1.ico"

Section "Main"
SetOutPath "$EXEDIR\"
CreateDirectory "$EXEDIR\Data"
ifFileExists "$EXEDIR\Data\Program Options.xml" checkhkcu 0
System::Call `kernel32::GetUserDefaultUILanguage() i.s`
Pop $3
StrCmp $3 "2052" 0 +3
StrCpy $4 "Chinese-Simplified"
goto +3
StrCmp $3 "1028" 0 checkhkcu
StrCpy $4 "Chinese-Traditional"
FileOpen $5 "$EXEDIR\Data\Program Options.xml" a
FileWrite $5 '<?xml version="1.0" encoding="utf-8"?>$\n'
FileWrite $5 "<TotalUninstall><Options><Interface><Language>$4</Language></Interface></Options></TotalUninstall>$\n"
FileClose $5
checkhkcu:
StrCpy $found 0
    ${LineFind} "$EXEDIR\Data\Program Options.xml" "/NUL" "1:-1" "GrepFunc"
    ${if} $found = 1
${textreplace::ReplaceInFile} "$EXEDIR\Data\Program Options.xml" "$EXEDIR\Data\Program Options.xml" "<Key>HKEY_USERS</Key>" "<Key>HKEY_CURRENT_USER</Key>" "/S=1" $8
${textreplace::FreeReadBuffer} "$8"
${textreplace::Unload}
    ${else}
Goto runprogram
    ${endIf}
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

Function GrepFunc
    ${TrimNewLines} '$R9' $R9
    System::Call "Shlwapi::StrStr(tR9, t`<Key>HKEY_USERS</Key>`)i .r0"
    ${if} $0 != 0
         StrCpy $found 1
         Push "StopLineFind"
    ${else}
         Push 0
   ${endIf}
FunctionEnd
