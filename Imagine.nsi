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
OutFile "右键关联.exe"
Icon "1.ico"

Section "Main"
	Call AssociationImagine
	Call AssociationHoneyview
	call Associationps
;	call AssociationXlideit
SectionEnd

Function AssociationImagine
${If} ${FileExists} "$EXEDIR\Imagine64.exe"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP" "" "Windows or OS/2 Bitmap"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\DefaultIcon" "" '"$EXEDIR\ICO.dll",0'
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\open" "icon" "$EXEDIR\Imagine64.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\open\command" "" '"$EXEDIR\Imagine64.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF" "" "Graphics Interchange Format"
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\DefaultIcon" "" '"$EXEDIR\ICO.dll",1'
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\open" "icon" "$EXEDIR\Imagine64.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\open\command" "" '"$EXEDIR\Imagine64.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.ICO" "" "Windows Icon"
	WriteRegStr   HKCU "Software\Classes\Imagine.ICO\DefaultIcon" "" "%1"
	WriteRegStr   HKCU "Software\Classes\Imagine.ICO\shell\open" "icon" "$EXEDIR\Imagine64.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.ICO\shell\open\command" "" '"$EXEDIR\Imagine64.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE" "" "JPEG - JFIF Compliant"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\DefaultIcon" "" '"$EXEDIR\ICO.dll",2'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\open" "icon" "$EXEDIR\Imagine64.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\open\command" "" '"$EXEDIR\Imagine64.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG" "" "JPEG - JFIF Compliant"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\DefaultIcon" "" '"$EXEDIR\ICO.dll",2'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\open" "icon" "$EXEDIR\Imagine64.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\open\command" "" '"$EXEDIR\Imagine64.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG" "" "JPEG - JFIF Compliant"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\DefaultIcon" "" '"$EXEDIR\ICO.dll",2'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\open" "icon" "$EXEDIR\Imagine64.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\open\command" "" '"$EXEDIR\Imagine64.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG" "" "Portable Network Graphics"
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\DefaultIcon" "" '"$EXEDIR\ICO.dll",3'
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\open" "icon" "$EXEDIR\Imagine64.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\open\command" "" '"$EXEDIR\Imagine64.exe" "%1"'
	MessageBox MB_OK|MB_ICONINFORMATION `更新优化Imagine64.exe部分关联菜单以及显示图标`
${Else}
	MessageBox MB_OK|MB_ICONINFORMATION `没有找到Imagine64.exe，请把本程序放到Imagine64.exe当前目录`
${EndIf}
FunctionEnd

Function AssociationHoneyview
${If} ${FileExists} "C:\mysoft\HoneyView\Honeyview.exe"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\xhview" "" "HoneyView"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\xhview" "Icon" "C:\mysoft\HoneyView\Honeyview.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\xhview\command" "" '"C:\mysoft\HoneyView\Honeyview.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\xhview" "" "HoneyView"
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\xhview" "Icon" "C:\mysoft\HoneyView\Honeyview.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\xhview\command" "" '"C:\mysoft\HoneyView\Honeyview.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\xhview" "" "HoneyView"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\xhview" "Icon" "C:\mysoft\HoneyView\Honeyview.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\xhview\command" "" '"C:\mysoft\HoneyView\Honeyview.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\xhview" "" "HoneyView"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\xhview" "Icon" "C:\mysoft\HoneyView\Honeyview.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\xhview\command" "" '"C:\mysoft\HoneyView\Honeyview.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\xhview" "" "HoneyView"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\xhview" "Icon" "C:\mysoft\HoneyView\Honeyview.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\xhview\command" "" '"C:\mysoft\HoneyView\Honeyview.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\xhview" "" "HoneyView"
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\xhview" "Icon" "C:\mysoft\HoneyView\Honeyview.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\xhview\command" "" '"C:\mysoft\HoneyView\Honeyview.exe" "%1"'
	MessageBox MB_OK|MB_ICONINFORMATION `添加Honeyview部分关联菜单`
${Else}
	MessageBox MB_OK|MB_ICONINFORMATION `没有找到Honeyview，请确认Honeyview安装在C:\mysoft\HoneyView目录`
${EndIf}
FunctionEnd

Function Associationps
${If} ${FileExists} "C:\Program Files\Adobe\Photoshop CC\Photoshop.exe"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\wedit" "" "编辑(&E)"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\wedit" "icon" "C:\Program Files\Adobe\Photoshop CC\Photoshop.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\wedit\command" "" '"C:\Program Files\Adobe\Photoshop CC\Photoshop.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\wedit" "" "编辑(&E)"
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\wedit" "icon" "C:\Program Files\Adobe\Photoshop CC\Photoshop.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\wedit\command" "" '"C:\Program Files\Adobe\Photoshop CC\Photoshop.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\wedit" "" "编辑(&E)"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\wedit" "icon" "C:\Program Files\Adobe\Photoshop CC\Photoshop.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\wedit\command" "" '"C:\Program Files\Adobe\Photoshop CC\Photoshop.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\wedit" "" "编辑(&E)"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\wedit" "icon" "C:\Program Files\Adobe\Photoshop CC\Photoshop.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\wedit\command" "" '"C:\Program Files\Adobe\Photoshop CC\Photoshop.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\wedit" "" "编辑(&E)"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\wedit" "icon" "C:\Program Files\Adobe\Photoshop CC\Photoshop.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\wedit\command" "" '"C:\Program Files\Adobe\Photoshop CC\Photoshop.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\wedit" "" "编辑(&E)"
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\wedit" "icon" "C:\Program Files\Adobe\Photoshop CC\Photoshop.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\wedit\command" "" '"C:\Program Files\Adobe\Photoshop CC\Photoshop.exe" "%1"'
	MessageBox MB_OK|MB_ICONINFORMATION `添加Photoshop部分关联菜单`
${Else}
	MessageBox MB_OK|MB_ICONINFORMATION `没有找到Photoshop，请确认Photoshop安装在C:\Program Files\Adobe\Photoshop CC目录`
${EndIf}
FunctionEnd

Function AssociationXlideit
${If} ${FileExists} "D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\Xlideit" "" "Xlideit"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\Xlideit" "icon" "D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.BMP\shell\Xlideit\command" "" '"D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\Xlideit" "" "Xlideit"
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\Xlideit" "icon" "D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.GIF\shell\Xlideit\command" "" '"D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\Xlideit" "" "Xlideit"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\Xlideit" "icon" "D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPE\shell\Xlideit\command" "" '"D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\Xlideit" "" "Xlideit"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\Xlideit" "icon" "D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPEG\shell\Xlideit\command" "" '"D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\Xlideit" "" "Xlideit"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\Xlideit" "icon" "D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.JPG\shell\Xlideit\command" "" '"D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe" "%1"'
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\Xlideit" "" "Xlideit"
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\Xlideit" "icon" "D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe,0"
	WriteRegStr   HKCU "Software\Classes\Imagine.PNG\shell\Xlideit\command" "" '"D:\Program Files\My Software\Media player\Xlideit\Xlideit.exe" "%1"'
	MessageBox MB_OK|MB_ICONINFORMATION `添加Xlideit部分关联菜单`
${Else}
	MessageBox MB_OK|MB_ICONINFORMATION `没有找到Xlideit，请确认Xlideit安装在D:\Program Files\My Software\Media player\Xlideit目录`
${EndIf}
FunctionEnd

