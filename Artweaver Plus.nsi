; NSIS with Registry.nsh in Include and Registry.dll in Plugins

; **************************************************************************
; === Define constants ===
; **************************************************************************
!define APPNAME 	"Artweaver"	; complete name of program
!define APP 		"Artweaver"	; short name of program without space and accent  this one is used for the final executable an in the directory structure
!define APPEXE 		"Artweaver.exe"	; main exe name
!define APPDIR 		"App\Artweaver Plus 6"	; main exe relative path

; ---Define Local Dirs and Portable Dirs ---
	!define LOCALDIR1 "$APPDATA\Artweaver Plus"
	!define PORTABLEDIR1 "$EXEDIR\Data\Artweaver Plus"

;--- Define RegKeys ---
	!define REGKEY1 "HKEY_CURRENT_USER\Software\Artweaver Plus"

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
SetOutPath "$EXEDIR\${APPDIR}"
${GetParameters} $0
ExecWait `"$EXEDIR\${APPDIR}\${APPEXE}" $0`
WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "GoodExit" "true"
FunctionEnd

Function CheckJunction
	ReadINIStr $0 "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "Junction"
  StrCmp $0 "true" 0 +6
InitPluginsDir
File "/oname=$PLUGINSDIR\junction.exe" "junction.exe"
	Call BackupLocalDirsJunction
	Call RestorePortableDirsJunction
	Goto +3
	Call BackupLocalDirs
	Call RestorePortableDirs
FunctionEnd


Function CheckRestore
	ReadINIStr $0 "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "Junction"
  StrCmp $0 "true" 0 +4
	Call BackupPortableDirsJunction
	Call RestoreLocalDirsJunction
	Goto +3
	Call BackupPortableDirs
	Call RestoreLocalDirs
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
;Check NTFS En/un ableJunction 下面这条表示获取系统安装路径并且提取前3个字符,通常是"c:\"
StrCpy $0 $WINDIR 3
System::Call 'Kernel32::GetVolumeInformation(t "$0",t,i ${NSIS_MAX_STRLEN},*i,*i,*i,t.r1,i ${NSIS_MAX_STRLEN})i.r0'
StrCmpS $1 NTFS +3
WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "Junction" "false"
Goto +2
WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "Junction" "true"
FunctionEnd


; **************************************************************************
; ==== Actions on Folders =====
; **************************************************************************
Function BackupLocalDirs
  SetShellVarContext all
	RMDir "/r" "${LOCALDIR1}-BackupBy${APP}Portable"
	Rename "${LOCALDIR1}" "${LOCALDIR1}-BackupBy${APP}Portable"
	SetShellVarContext current
		RMDir "/r" "${LOCALDIR1}-BackupBy${APP}Portable"
	Rename "${LOCALDIR1}" "${LOCALDIR1}-BackupBy${APP}Portable"
FunctionEnd

Function RestorePortableDirs
  SetShellVarContext all
	CreateDirectory "${LOCALDIR1}"
	CopyFiles /SILENT "${PORTABLEDIR1}\*.*" "${LOCALDIR1}"
	SetShellVarContext current
	CreateDirectory "${LOCALDIR1}"
	CopyFiles /SILENT "${PORTABLEDIR1}\*.*" "${LOCALDIR1}"
FunctionEnd

Function BackupPortableDirs
  SetShellVarContext all
	RMDir "/r" "${PORTABLEDIR1}"
	CreateDirectory "${PORTABLEDIR1}"
	CopyFiles /SILENT "${LOCALDIR1}\*.*" "${PORTABLEDIR1}"
	SetShellVarContext current
	RMDir "/r" "${PORTABLEDIR1}"
	CreateDirectory "${PORTABLEDIR1}"
	CopyFiles /SILENT "${LOCALDIR1}\*.*" "${PORTABLEDIR1}"
FunctionEnd

Function RestoreLocalDirs
  SetShellVarContext all
	RMDir "/r" "${LOCALDIR1}"
	Rename "${LOCALDIR1}-BackupBy${APP}Portable" "${LOCALDIR1}"
	RMDir "${LOCALDIR1}"
	SetShellVarContext current
	RMDir "/r" "${LOCALDIR1}"
	Rename "${LOCALDIR1}-BackupBy${APP}Portable" "${LOCALDIR1}"
	RMDir "${LOCALDIR1}"
FunctionEnd

; **************************************************************************
; ==== Actions on Folders Use Junction=====
; **************************************************************************

Function BackupLocalDirsJunction
  SetShellVarContext all
	ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q -d $\"${LOCALDIR1}-BackupBy${APP}Portable$\""
	RMDir "/r" "${LOCALDIR1}-BackupBy${APP}Portable"
	Rename "${LOCALDIR1}" "${LOCALDIR1}-BackupBy${APP}Portable"
	SetShellVarContext current
	ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q -d $\"${LOCALDIR1}-BackupBy${APP}Portable$\""
	RMDir "/r" "${LOCALDIR1}-BackupBy${APP}Portable"
	Rename "${LOCALDIR1}" "${LOCALDIR1}-BackupBy${APP}Portable"
FunctionEnd

Function RestorePortableDirsJunction
  SetShellVarContext all
  ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q $\"${LOCALDIR1}$\" $\"${PORTABLEDIR1}$\""
	SetShellVarContext current
	ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q $\"${LOCALDIR1}$\" $\"${PORTABLEDIR1}$\""
FunctionEnd

Function BackupPortableDirsJunction
  SetShellVarContext all
  ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q -d $\"${LOCALDIR1}$\""
	SetShellVarContext current
  ExecDos::exec /TOSTACK "$\"$PLUGINSDIR\junction.exe$\" -accepteula -q -d $\"${LOCALDIR1}$\""
FunctionEnd

Function RestoreLocalDirsJunction
  SetShellVarContext all
	Rename "${LOCALDIR1}-BackupBy${APP}Portable" "${LOCALDIR1}"
	SetShellVarContext current
	Rename "${LOCALDIR1}-BackupBy${APP}Portable" "${LOCALDIR1}"
FunctionEnd



; **************************************************************************
; ==== Actions on Registry Keys =====
; **************************************************************************
Function BackupLocalKeys
	${registry::DeleteKey} "${REGKEY1}-BackupBy${APP}Portable" $R0
	${registry::MoveKey} "${REGKEY1}" "${REGKEY1}-BackupBy${APP}Portable" $R0
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
Sleep 100
FunctionEnd

Function RestoreLocalKeys
	${registry::DeleteKey} "${REGKEY1}" $R0
	${registry::MoveKey} "${REGKEY1}-BackupBy${APP}Portable" "${REGKEY1}" $R0
	${registry::DeleteKey} "HKEY_CURRENT_USER\Software\Sysinternals\Junction" $R0
Sleep 50
${registry::Unload}
FunctionEnd
