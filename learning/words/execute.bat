@echo off
setlocal enabledelayedexpansion

REM Variables
set PROJECT_FILE=test.gpr
set BUILD_DIR=obj
set TEST_EXEC=run_tests.exe

echo Building project...
gprbuild -p -P %PROJECT_FILE%
if errorlevel 1 (
    echo Build failed.
    exit /b 1
)

if exist .\%TEST_EXEC% (
    echo Running tests...
    .\%TEST_EXEC%
) else (
    echo Error: %TEST_EXEC% not found.
    exit /b 1
)

echo Cleaning build artifacts...
rmdir /s /q %BUILD_DIR%
del /f /q %TEST_EXEC%

echo Done.