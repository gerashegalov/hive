@echo off
@rem Licensed to the Apache Software Foundation (ASF) under one or more
@rem contributor license agreements.  See the NOTICE file distributed with
@rem this work for additional information regarding copyright ownership.
@rem The ASF licenses this file to You under the Apache License, Version 2.0
@rem (the "License"); you may not use this file except in compliance with
@rem the License.  You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.

set DEFAULT_WAREHOUSE_DIR=/user/hive/warehouse
set DEFAULT_TMP_DIR=/tmp

set WAREHOUSE_DIR=%DEFAULT_WAREHOUSE_DIR%
set TMP_DIR=%DEFAULT_TMP_DIR%
set HELP=
set SCRIPT_NAME=%0

@rem parse the command line arguments
:ProcessCmdLine 
	if [%1]==[] goto :FinishArgs  
	
	if %1==--warehouse-dir (
		set WAREHOUSE_DIR=%2
		shift		
		shift
		goto :ProcessCmdLine 
	)

	if %1==--tmp-dir (		
		set TMP_DIR=%2
		shift
		shift
		goto :ProcessCmdLine 
	)
		
	if %1==--help (
		set HELP=_help 
		shift
		goto :ProcessCmdLine 
	)
	
	@rem parameter at %1 does not match any option
	echo Invalid parameter: %1
	set HELP=_help
	goto :FinishArgs
:FinishArgs  

if defined HELP (
	echo Usage %SCRIPT_NAME% [--warehouse-dir <Hive user>] [--tmp-dir <Tmp dir>]
	echo Default value of warehouse directory is: [%DEFAULT_WAREHOUSE_DIR%]
	echo Default value of the temporary directory is: [%DEFAULT_TMP_DIR%]
	exit /b 1
)

if not defined HADOOP_HOME (
	echo HADOOP_HOME needs to be defined to point at the hadoop installation
	exit /b 1
)

set HADOOP_EXEC=%HADOOP_HOME%\bin\hadoop.cmd
if not exist %HADOOP_EXEC% (
	echo Missing hadoop installation: HADOOP_HOME must be set
	exit /b 1
)

cmd /C  %HADOOP_EXEC% fs -mkdir %TMP_DIR%  > /NUL 2>&1
echo Setting writeable group rights for directory [%TMP_DIR%]
cmd /C %HADOOP_EXEC% fs -chmod g+w %TMP_DIR%
cmd /C  %HADOOP_EXEC% fs -mkdir %WAREHOUSE_DIR% > /NUL 2>&1
echo Setting writeable group rights for directory [%WAREHOUSE_DIR%]
cmd /C %HADOOP_EXEC% fs -chmod g+w %WAREHOUSE_DIR%

echo Initialization done.
echo Please, do not forget to set the following configuration properties in hive-site.xml:
echo hive.metastore.warehouse.dir=%WAREHOUSE_DIR%
echo hive.exec.scratchdir=%TMP_DIR%

goto :EOF
