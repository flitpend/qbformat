@ECHO OFF
CHCP 65001
SETLOCAL ENABLEDELAYEDEXPANSION


REM Heading level 1-4 represented by variables h1-h4
SET /A h1=1
SET /A h2=1
SET /A h3=1
SET /A h4=1


GOTO :main


REM Heading number format
:updqr
SET part1=
SET part2=

IF %~1==1 SET "part1=十"
IF %~1==2 SET "part1=二十"
IF %~1==3 SET "part1=三十"
IF %~1==4 SET "part1=四十"
IF %~1==5 SET "part1=五十"
IF %~1==6 SET "part1=六十"
IF %~1==7 SET "part1=七十"
IF %~1==8 SET "part1=八十"
IF %~1==9 SET "part1=九十"

IF %~2==1 SET "part2=一"
IF %~2==2 SET "part2=二"
IF %~2==3 SET "part2=三"
IF %~2==4 SET "part2=四"
IF %~2==5 SET "part2=五"
IF %~2==6 SET "part2=六"
IF %~2==7 SET "part2=七"
IF %~2==8 SET "part2=八"
IF %~2==9 SET "part2=九"
EXIT /B 0


REM Heading string for levels 1-4
:updht
IF %~1==h1 (
    SET /A quotient=%~2/10
    SET /A remainder=%~2%%10

    CALL :updqr !quotient! !remainder!
    SET "ht1=# !part1!!part2!、"
    EXIT /B 0
)
IF %~1==h2 (
    SET /A quotient=%~2/10
    SET /A remainder=%~2%%10

    CALL :updqr !quotient! !remainder!
    SET "ht2=## （!part1!!part2!）"
    EXIT /B 0
)
IF %~1==h3 (
    SET "ht3=### %~2."
    EXIT /B 0
)
IF %~1==h4 (
    SET "ht4=#### （%~2）"
    EXIT /B 0
)
EXIT /B 0


:format
REM Loop through source file
FOR /F "tokens=*" %%l IN (!txtfilename!.txt) DO (
REM Get the first word from each line
    FOR /F "tokens=1" %%z IN ("%%l") DO SET firstword=%%z
REM Get the rest of the line
    FOR /F "delims=#" %%y IN ("%%l") DO SET restofline=%%y
    FOR /F "tokens=1" %%y IN ("!restofline!") DO SET restofline=%%y

    SET line=%%l

    IF !firstword!==# (
        CALL :updht h1 !h1!
        SET /A h1+=1
        SET /A h2=1
        SET /A h3=1
        SET /A h4=1
        SET line=!ht1!!restofline!
    )
    IF !firstword!==## (
        CALL :updht h2 !h2!
        SET /A h2+=1
        SET /A h3=1
        SET /A h4=1
        SET line=!ht2!!restofline!
    )
    IF !firstword!==### (
        CALL :updht h3 !h3!
        SET /A h3+=1
        SET /A h4=1
        SET line=!ht3!!restofline!
    )
    IF !firstword!==#### (
        CALL :updht h4 !h4!
        SET /A h4+=1
        SET line=!ht4!!restofline!
    )

    ECHO !line! >> !txtfilename!_temp.txt
    ECHO. >> !txtfilename!_temp.txt
)
EXIT /B 0


:main
FOR %%a IN (*.txt) DO (
    SET txtfilename=%%~na
    SET /A h1=1
    SET /A h2=1
    SET /A h3=1
    SET /A h4=1

    CALL :format

    pandoc -o !txtfilename!.docx !txtfilename!_temp.txt --reference-doc t.docx
    DEL !txtfilename!_temp.txt
)


ENDLOCAL
