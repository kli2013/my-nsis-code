!define APP "123321"

SetCompressor /SOLID lzma
SetCompressorDictSize 32

!include "x64.nsh"
!include TextFunc.nsh
!insertmacro GetParameters

WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel admin

Name "${APP} Loader"
OutFile "..\${APP}.exe"
Icon "${APP}.ico"

Section "Main"
SetOutPath "$EXEDIR\"
${GetParameters} $0
${If} ${RunningX64}
${AndIf} ${FileExists} "$EXEDIR\x64\${APP}.exe"
Exec `"$EXEDIR\x64\${APP}.exe" $0`
${Else}
Exec `"$EXEDIR\x86\${APP}.exe" $0`
${EndIf}
SectionEnd
