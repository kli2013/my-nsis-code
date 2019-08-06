!define APP "Total Uninstall"

!include "TextReplace.nsh"

SetCompressor /SOLID lzma
SetCompressorDictSize 32

WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel admin

Name "${APP} set"
OutFile "..\设置HKCU.exe"

Section "Main"
${textreplace::ReplaceInFile} "$EXEDIR\Data\Program Options.xml" "$EXEDIR\Data\Program Options.xml" "<Key>HKEY_USERS</Key>" "<Key>HKEY_CURRENT_USER</Key>" "/S=1" $4
${textreplace::FreeReadBuffer} "$4"
${textreplace::Unload}
SectionEnd
