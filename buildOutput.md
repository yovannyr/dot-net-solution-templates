### Sample build output. ###

```

C:\code\test1\LineOfBusinessWebApplication6>LibrariesAndTools\tools\nant\nant.exe -buildfile:nant.build build 
NAnt 0.86 (Build 0.86.3075.0; nightly; 6/2/2008)
Copyright (C) 2001-2008 Gerry Shaw
http://nant.sourceforge.net

Buildfile: file:///C:/code/test1/LineOfBusinessWebApplication6/nant.build
Target framework: Microsoft .NET Framework 3.5
Target(s) specified: build 

   [script] Scanning assembly "t0ljmtlg" for extensions.
   [script] Scanning assembly "3yvkrt-j" for extensions.

version:


init:

   [delete] Deleting directory 'C:\code\test1\LineOfBusinessWebApplication6\build'.
    [mkdir] Creating directory 'C:\code\test1\LineOfBusinessWebApplication6\build'.
     [echo] Current Directory: C:\code\test1\LineOfBusinessWebApplication6

commonassemblyinfo:

     [echo] MARKING THIS BUILD AS VERSION 1.0.9999.0
   [delete] Deleting file C:\code\test1\LineOfBusinessWebApplication6\src\CommonAssemblyInfo.cs.
  [asminfo] Generated file 'C:\code\test1\LineOfBusinessWebApplication6\src\CommonAssemblyInfo.cs'.

compile:

     [echo] Build Directory is build
     [exec] Microsoft (R) Build Engine Version 3.5.21022.8
     [exec] [Microsoft .NET Framework, Version 2.0.50727.1433]
     [exec] Copyright (C) Microsoft Corporation 2007. All rights reserved.
     [exec] 
     [exec] Microsoft (R) Build Engine Version 3.5.21022.8
     [exec] [Microsoft .NET Framework, Version 2.0.50727.1433]
     [exec] Copyright (C) Microsoft Corporation 2007. All rights reserved.
     [exec] 

asp-compile:


dropDatabase:


manageSqlDatabase:

Drop LineOfBusinessWebApplication6 on localhost\sqlexpress

Dropping connections for database LineOfBusinessWebApplication6


createDatabase:


manageSqlDatabase:

Create LineOfBusinessWebApplication6 on localhost\sqlexpress using scripts from C:\code\test1\LineOfBusinessWebApplication6\src\Infrastructure\Database

     [echo] Current Database Version: 0

move-for-test:

     [copy] Copying 9 files to 'C:\code\test1\LineOfBusinessWebApplication6\build\net-3.5-release'.

test:

    [mkdir] Creating directory 'C:\code\test1\LineOfBusinessWebApplication6\build\results'.
   [nunit2] Tests run: 1, Failures: 0, Not run: 0, Time: 0.020 seconds
   [nunit2] 
   [nunit2] 
   [nunit2] 
   [nunit2] Tests run: 1, Failures: 0, Not run: 0, Time: 0.030 seconds
   [nunit2] 
   [nunit2] 
   [nunit2] 
   [nunit2] Tests run: 0, Failures: 0, Not run: 0, Time: 0.000 seconds
   [nunit2] 
   [nunit2] 
   [nunit2] 

build:


BUILD SUCCEEDED

Total time: 12.5 seconds.


```