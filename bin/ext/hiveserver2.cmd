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

set CLASS=org.apache.hive.service.server.HiveServer2
pushd %HIVE_LIB%
for /f %%a IN ('dir /b hive-service-*.jar') do (
  set JAR=%HIVE_LIB%\%%a
)
popd

if [%1]==[hiveserver2_help] goto :hiveserver2_help

if [%1]==[hiveserver2_catservice] goto :hiveserver2_catservice

:hiveserver2
  echo "Starting Hive Thrift Server"

  @rem hadoop 20 or newer - skip the aux_jars option and hiveconf
  call %HIVE_BIN_PATH%\ext\util\execHiveCmd.cmd %CLASS%
goto :EOF

:hiveserver2_help
  set HIVEARGS=-h
  goto :hiveserver2
goto :EOF

:hiveserver2_catservice
@echo ^<service^>
@echo   ^<id^>HiveServer2^</id^>
@echo   ^<name^>HiveServer2^</name^>
@echo   ^<description^>Hadoop HiveServer2 Service^</description^>
@echo   ^<executable^>%JAVA_HOME%\bin\java^</executable^>
@echo   ^<arguments^>%HADOOP_OPTS% %AUX_PARAM% -classpath %CLASSPATH% %CLASS% -hiveconf hive.hadoop.classpath=%HIVE_LIB%\* %HIVE_OPTS%^</arguments^>
@echo ^</service^>
goto :EOF
