; NSIS with Registry.nsh in Include and Registry.dll in Plugins

; **************************************************************************
; === Define constants ===
; **************************************************************************
!define APPNAME 	"WeChat"	; complete name of program
!define APP 		"WeChat"	; short name of program without space and accent  this one is used for the final executable an in the directory structure
!define APPEXE 		"WeChat.exe"	; main exe name
!define APPDIR 		"App\WeChat"	; main exe relative path

; ---Define Local Dirs and Portable Dirs ---
	!define LOCALDIR1 "$LOCALAPPDATA\CEF"
	!define PORTABLEDIR1 "$EXEDIR\Data\CEF"
	!define LOCALDIR2 "$APPDATA\Tencent\WeChat"
	!define PORTABLEDIR2 "$EXEDIR\Data\WeChat"

;--- Define RegKeys ---
	!define REGKEY1 "HKEY_CURRENT_USER\Software\Tencent\bugReport\WechatWindows"
	!define REGKEY2 "HKEY_CURRENT_USER\Software\Tencent\WeChat"
; **************************************************************************
; === Best Compression ===
; **************************************************************************
SetCompressor /SOLID lzma
SetCompressorDictSize 64

; **************************************************************************
; === Includes ===
; **************************************************************************
!include "Registry.nsh"
!include TextFunc.nsh
!insertmacro GetParameters
; **************************************************************************
; === Runtime Switches ===
; **************************************************************************
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user

; **************************************************************************
; === Set basic information ===
; **************************************************************************
Name "${APPNAME} Portable"
OutFile "..\${APP}Portable.exe"
Icon "${APP}.ico"

; **************************************************************************
; ==== Running ====
; **************************************************************************

Section "Main"
	Call CheckStart
	Call BeforeLaunch
	call SetAllDown

		Call Launch

	Call Restore

SectionEnd

Function SetAllDown
	Call CheckJunction
	Call BackupLocalKeys
	Call RestorePortableKeys
FunctionEnd

Function Restore
	call CheckRestore
	Call BackupPortableKeys
	Call RestoreLocalKeys
FunctionEnd

Function CheckStart
	Call CheckDirExe
	Call CheckRunExe
	Call CheckGoodExit
FunctionEnd

; **************************************************************************
; === Run Application ===
; **************************************************************************
Function Launch
	WriteRegStr   HKCU "Software\Tencent\bugReport\WechatWindows" "InstallDir" "$EXEDIR\App\WeChat"
	WriteRegStr   HKCU "Software\Tencent\WeChat" "FileSavePath" "$EXEDIR\Data"
SetOutPath "$EXEDIR\${APPDIR}"
${GetParameters} $0
ExecWait `"$EXEDIR\${APPDIR}\${APPEXE}" $0`
WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "GoodExit" "true"
FunctionEnd

Function CheckJunction
	ReadINIStr $0 "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "Junction"
  StrCmp $0 "true" +4
	Call BackupLocalDirs
	Call RestorePortableDirs
	Goto CheckJunctionEnd
InitPluginsDir
File "/oname=$PLUGINSDIR\junction.exe" "junction.exe"
	Call BackupLocalDirsJunction
	Call RestorePortableDirsJunction
CheckJunctionEnd:
FunctionEnd


Function CheckRestore
	ReadINIStr $0 "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "Junction"
  StrCmp $0 "true" +4
	Call BackupPortableDirs
	Call RestoreLocalDirs
	Goto CheckRestoreEnd
	Call BackupPortableDirsJunction
	Call RestoreLocalDirsJunction
CheckRestoreEnd:
FunctionEnd


Function CheckDirExe
	IfFileExists "$EXEDIR\${APPDIR}\${APPEXE}" +3
	MessageBox MB_OK|MB_ICONEXCLAMATION `没有在 $EXEDIR\${APPDIR} 发现目标程序 ${APPEXE}.`
	Abort
FunctionEnd

Function CheckRunExe
	ReadINIStr $0 "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "AllowMultipleInstances"
	StrCmp $0 "" 0 +2
	WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "AllowMultipleInstances" "false"
	FindProcDLL::FindProc "${APPEXE}"
		Pop $R0
		StrCmp $R0 "1" 0 CheckRunEnd
	ReadINIStr $0 "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "AllowMultipleInstances"
	StrCmp $0 "true" SecondLaunch
		MessageBox MB_OK|MB_ICONINFORMATION `另一个 ${APPNAME} 进程正在运行. 先结束该进程再重新运行 ${APP}Portable.`
		Abort
SecondLaunch:
	SetOutPath "$EXEDIR\${APPDIR}"
	${GetParameters} $0
	Exec `"$EXEDIR\${APPDIR}\${APPEXE}" $0`
	Abort
CheckRunEnd:
FunctionEnd


Function CheckGoodExit
	ReadINIStr $0 "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "GoodExit"
	StrCmp $0 "false" 0 CheckExitEnd
	ReadINIStr $0 "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "AllowMultipleInstances"
	StrCmp $0 "true" 0 +4
	FindProcDLL::FindProc "${APPEXE}"
		Pop $R0
		StrCmp $R0 "1" CheckExitEnd
	MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION `上一次程序没有正确退出.$\n是否尝试恢复?` IDOK RestoreNow IDCANCEL CheckExitEnd
	RestoreNow:
	Call Restore
	CheckExitEnd:
FunctionEnd


; **************************************************************************
; === Before Launching ===
; **************************************************************************
Function BeforeLaunch
	CreateDirectory "${PORTABLEDIR1}"
	WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "LastDirectory" "$EXEDIR"
	WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "GoodExit" "false"
;Check NTFS En/un ableJunction
StrCpy $0 $WINDIR 3
System::Call 'Kernel32::GetVolumeInformation(t "$0",t,i ${NSIS_MAX_STRLEN},*i,*i,*i,t.r1,i ${NSIS_MAX_STRLEN})i.r0'
StrCmpS $1 NTFS +3
WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "Junction" "false"
Goto BeforeLaunchEnd
WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "Junction" "true"
BeforeLaunchEnd:
FunctionEnd


; **************************************************************************
; ==== Actions on Folders =====
; **************************************************************************
Function BackupLocalDirs
	RMDir "/r" "${LOCALDIR1}-BackupBy${APP}Portable"
	Rename "${LOCALDIR1}" "${LOCALDIR1}-BackupBy${APP}Portable"
	RMDir "/r" "${LOCALDIR2}-BackupBy${APP}Portable"
	Rename "${LOCALDIR2}" "${LOCALDIR2}-BackupBy${APP}Portable"
FunctionEnd

Function RestorePortableDirs
	CreateDirectory "${LOCALDIR1}"
	CreateDirectory "${LOCALDIR2}"
	CopyFiles /SILENT "${PORTABLEDIR1}\*.*" "${LOCALDIR1}"
	CopyFiles /SILENT "${PORTABLEDIR2}\*.*" "${LOCALDIR2}"
FunctionEnd

Function BackupPortableDirs
	RMDir "/r" "${PORTABLEDIR1}"
	RMDir "/r" "${PORTABLEDIR2}"
	CreateDirectory "${PORTABLEDIR1}"
	CreateDirectory "${PORTABLEDIR2}"
	CopyFiles /SILENT "${LOCALDIR1}\*.*" "${PORTABLEDIR1}"
	CopyFiles /SILENT "${LOCALDIR2}\*.*" "${PORTABLEDIR2}"
FunctionEnd

Function RestoreLocalDirs
	RMDir "/r" "${LOCALDIR1}"
	Rename "${LOCALDIR1}-BackupBy${APP}Portable" "${LOCALDIR1}"
	RMDir "${LOCALDIR1}"
	RMDir "/r" "${LOCALDIR2}"
	Rename "${LOCALDIR2}-BackupBy${APP}Portable" "${LOCALDIR2}"
	RMDir "${LOCALDIR2}"
FunctionEnd

; **************************************************************************
; ==== Actions on Folders Use Junction=====
; **************************************************************************

Function BackupLocalDirsJunction
ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q -d $\"${LOCALDIR1}-BackupBy${APP}Portable$\""
	RMDir "/r" "${LOCALDIR1}-BackupBy${APP}Portable"
	Rename "${LOCALDIR1}" "${LOCALDIR1}-BackupBy${APP}Portable"
ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q -d $\"${LOCALDIR2}-BackupBy${APP}Portable$\""
	RMDir "/r" "${LOCALDIR2}-BackupBy${APP}Portable"
	Rename "${LOCALDIR2}" "${LOCALDIR2}-BackupBy${APP}Portable"
FunctionEnd

Function RestorePortableDirsJunction
CreateDirectory "${PORTABLEDIR1}"
CreateDirectory "${PORTABLEDIR2}"
ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q $\"${LOCALDIR1}$\" $\"${PORTABLEDIR1}$\""
ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q $\"${LOCALDIR2}$\" $\"${PORTABLEDIR2}$\""
FunctionEnd

Function BackupPortableDirsJunction
ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q -d $\"${LOCALDIR1}$\""
ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q -d $\"${LOCALDIR2}$\""
FunctionEnd

Function RestoreLocalDirsJunction
	Rename "${LOCALDIR1}-BackupBy${APP}Portable" "${LOCALDIR1}"
	Rename "${LOCALDIR1}-BackupBy${APP}Portable" "${LOCALDIR2}"
FunctionEnd



; **************************************************************************
; ==== Actions on Registry Keys =====
; **************************************************************************
Function BackupLocalKeys
	${registry::DeleteKey} "${REGKEY1}-BackupBy${APP}Portable" $R0
	${registry::MoveKey} "${REGKEY1}" "${REGKEY1}-BackupBy${APP}Portable" $R0
	${registry::DeleteKey} "${REGKEY2}-BackupBy${APP}Portable" $R0
	${registry::MoveKey} "${REGKEY2}" "${REGKEY2}-BackupBy${APP}Portable" $R0
Sleep 50
FunctionEnd

Function RestorePortableKeys
${registry::RestoreKey} "$EXEDIR\Data\${APP}.reg" $R0
Sleep 200
FunctionEnd

Function BackupPortableKeys
Delete "$EXEDIR\Data\${APP}.reg"
CreateDirectory "$EXEDIR\Data"
	${registry::SaveKey} "${REGKEY1}" "$EXEDIR\Data\${APP}.reg" "/A=1" $R0
	${registry::SaveKey} "${REGKEY2}" "$EXEDIR\Data\${APP}.reg" "/A=1" $R0
Sleep 100
FunctionEnd

Function RestoreLocalKeys
	${registry::DeleteKey} "${REGKEY1}" $R0
	${registry::MoveKey} "${REGKEY1}-BackupBy${APP}Portable" "${REGKEY1}" $R0
	${registry::DeleteKey} "${REGKEY2}" $R0
	${registry::MoveKey} "${REGKEY2}-BackupBy${APP}Portable" "${REGKEY2}" $R0
	${registry::DeleteKey} "HKEY_CURRENT_USER\Software\Sysinternals\Junction" $R0
Sleep 50
${registry::Unload}
FunctionEnd
