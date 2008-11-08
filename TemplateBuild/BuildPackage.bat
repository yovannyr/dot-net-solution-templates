del working\content\*.zip /q
del output\*.* /q
rem copy "%USERPROFILE%\My Documents\Visual Studio 2008\My Exported Templates\*.zip" input
rem @FOR %%i IN (input\*.zip) DO tools\7za x -r %%i -oworking\template\%%~ni -y *.*
tools\nant\nant.exe SetProjectProperties -buildfile:tools\nant.build -D:template.path=..\working\template\LibrariesAndTools\MyTemplate.vstemplate
cd working\template
..\..\tools\7za a -r ..\content\template.zip *.*
cd ..\content
..\..\tools\7za a -r  ..\..\output\content.zip *.*
cd..\..\output
..\tools\MakeZipExe.exe -zipfile:content.zip
rename content.exe content.vsi
cd ..
pause