@echo off
rem Codex hook -> Git Bash bridge.
rem On machines where `bash` on PATH is the WSL stub (WindowsApps) or missing,
rem hooks fail with exit 1. cmd.exe always exists, so locate Git Bash directly
rem from standard install paths or next to git.exe.
rem Usage: codex_hook.cmd <path relative to ~/.claude>  (.py -> python, else bash)
rem stdin (hook JSON) and exit codes (2 = block) pass through unchanged.
rem NOTE: keep this file ASCII-only ? cmd parses batch files in the OEM codepage.
setlocal
set "TARGET=%~1"
set "GITBASH="
if exist "%ProgramFiles%\Git\bin\bash.exe" set "GITBASH=%ProgramFiles%\Git\bin\bash.exe"
if not defined GITBASH if exist "%ProgramFiles(x86)%\Git\bin\bash.exe" set "GITBASH=%ProgramFiles(x86)%\Git\bin\bash.exe"
if not defined GITBASH if exist "%LocalAppData%\Programs\Git\bin\bash.exe" set "GITBASH=%LocalAppData%\Programs\Git\bin\bash.exe"
if not defined GITBASH for /f "delims=" %%G in ('where git 2^>nul') do if not defined GITBASH if exist "%%~dpG..\bin\bash.exe" set "GITBASH=%%~dpG..\bin\bash.exe"
if not defined GITBASH exit /b 0
if /i "%TARGET:~-3%"==".py" (
  "%GITBASH%" -c "python ~/.claude/%TARGET%"
) else (
  "%GITBASH%" -c "bash ~/.claude/%TARGET%"
)
exit /b %errorlevel%
