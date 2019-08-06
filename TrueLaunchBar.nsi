!define APP "TrueLaunchBar"
!include nsDialogs.nsh
!include "x64.nsh"
!include nsWindows.nsh
SetCompressor /SOLID lzma
SetCompressorDictSize 32
RequestExecutionLevel admin
Name "TrueLaunchBar"
OutFile "..\GreenTrueLaunchBar.EXE"
Icon "1.ico"

LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
;新建一个自定义页面
Page custom nsDialogsShow

;为使用的控件句柄分配个变量。
Var WINDOW
Var Button1
Var Button2
Var Button3

Function nsDialogsShow
;创建一个NSD窗口,几个按钮,一个ProgressBar
nsDialogs::Create 1018
  Pop $WINDOW
  ${If} $WINDOW == error
    Abort
  ${EndIf}
GetDlgItem $0 $HWNDPARENT 1028
ShowWindow $0 ${SW_HIDE}
GetDlgItem $0 $HWNDPARENT 2
ShowWindow $0 ${SW_HIDE}
GetDlgItem $0 $HWNDPARENT 1
ShowWindow $0 ${SW_HIDE}
    ${NSW_SetWindowSize} $HWNDPARENT 220 80 ;改变窗体大小
    ${NSW_SetWindowSize} $WINDOW 220 80 ;改变Page大小
Pop $WINDOW
${NSD_CreateButton} 0u 3u 40u 18u "便携运行"
Pop $Button1
${NSD_OnClick} $Button1 Button1_OnClick

${NSD_CreateButton} 45u 3u 40u 18u "安装"
Pop $Button2
${NSD_OnClick} $Button2 Button2_OnClick

${NSD_CreateButton} 90u 3u 40u 18u "卸载"
Pop $Button3
${NSD_OnClick} $Button3 Button3_OnClick

nsDialogs::Show
FunctionEnd

Function Button1_OnClick
SetOutPath "$EXEDIR\"
${If} ${RunningX64}
${AndIf} ${FileExists} "$EXEDIR\x64\tlbHost.exe"
Exec "$EXEDIR\x64\tlbHost.exe"
${Else}
Exec "$EXEDIR\x86\tlbHost.exe"
${EndIf}
SendMessage $HWNDPARENT ${WM_CLOSE} 0 0
FunctionEnd

Function Button2_OnClick
SetOutPath "$EXEDIR\"
${If} ${RunningX64}
${AndIf} ${FileExists} "$EXEDIR\x64\tlb.dll"
Execshell open "$SYSDIR\regsvr32.exe" "/s $\"$EXEDIR\x64\tlb.dll$\""
${Else}
Execshell open "$SYSDIR\regsvr32.exe" "/s $\"$EXEDIR\x86\tlb.dll$\""
${EndIf}
MessageBox MB_OKCANCEL `右键2次任务栏激活程序，$\n在工具栏选择TrueLaunchBar。` IDOK
SendMessage $HWNDPARENT ${WM_CLOSE} 0 0
FunctionEnd

Function Button3_OnClick
SetOutPath "$EXEDIR\"
${If} ${RunningX64}
${AndIf} ${FileExists} "$EXEDIR\x64\tlb.dll"
Execshell open "$SYSDIR\regsvr32.exe" "/s /u $\"$EXEDIR\x64\tlb.dll$\""
${Else}
Execshell open "$SYSDIR\regsvr32.exe" "/s /u $\"$EXEDIR\x86\tlb.dll$\""
${EndIf}
DeleteRegKey HKLM "SOFTWARE\Classes\Component Categories\{49E86696-EAA6-45A2-9480-C78C013B9713}"
DeleteRegKey HKLM "SOFTWARE\True Software"
DeleteRegKey HKCU "SOFTWARE\True Software"
MessageBox MB_OKCANCEL `TrueLaunchBar已经卸载，$\n工具栏取消勾选后，$\n程序目录可任意处置。` IDOK
SendMessage $HWNDPARENT ${WM_CLOSE} 0 0
FunctionEnd

Section
SectionEnd


