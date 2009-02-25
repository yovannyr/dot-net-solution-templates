del working\content\*.zip /q
del output\*.* /q
rem copy "%USERPROFILE%\My Documents\Visual Studio 2008\My Exported Templates\*.zip" input
rem @FOR %%i IN (input\*.zip) DO tools\7za x -r %%i -oworking\template\%%~ni -y *.*
rem Sets the open in browser file.
tools\nant\nant.exe SetProjectProperties -buildfile:tools\nant.build -D:template.path=..\working\template\LibrariesAndTools\MyTemplate.vstemplate
cd working\onion
del /Q /S *.*
xcopy /s c:\temp\CodeCampServer\*.* 
..\..\tools\7za a -r ..\content\template.zip *.*
cd ..\content
..\..\tools\7za a -r  ..\..\output\content.zip *.*
cd..\..\output
..\tools\MakeZipExe.exe -zipfile:content.zip
rename content.exe content.vsi
cd ..

"C:\Program Files (x86)\Common Files\microsoft shared\vscontentinstaller.exe" output\content.vsi