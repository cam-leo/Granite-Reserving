@echo off
setlocal
rem Commits and pushes this project to GitHub. Run it from this folder:  .\publish.cmd
cd /d "%~dp0"

where git >nul 2>nul
if errorlevel 1 goto nogit

rem --- Anything to upload? ---
set CHANGED=
for /f "delims=" %%i in ('git status --porcelain') do set CHANGED=1
if not defined CHANGED goto nothing

echo.
echo Changes to upload:
git status --short
echo.

rem --- Commit message (Enter for the default) ---
set "MSG="
set /p MSG=Commit message (Enter for "Update"): 
if not defined MSG set "MSG=Update"

git add -A

rem --- Safety check 1: never upload keys or passwords ---
git diff --cached --name-only | findstr /i /r "\.env \.pem$ \.key$ secret" >nul
if not errorlevel 1 goto keysstaged

rem --- Safety check 2: no file over 50 MB (GitHub refuses 100 MB; data belongs in data/, which is ignored) ---
set BIG=
for /f "delims=" %%i in ('powershell -NoProfile -Command "git diff --cached --name-only | ForEach-Object { if ((Test-Path -LiteralPath $_) -and ((Get-Item -LiteralPath $_).Length -gt 50MB)) { $_ } }"') do set BIG=%%i
if defined BIG goto toobig

git commit -q -m "%MSG%"
if errorlevel 1 goto commitfailed

echo.
echo Uploading...
git push -u origin main
if errorlevel 1 goto pushfailed

echo.
echo Done! Refresh your repository page on GitHub to see the changes.
pause
exit /b 0

:nothing
echo Nothing has changed since the last upload.
pause
exit /b 0

:nogit
echo Git isn't installed. Install it from https://git-scm.com/download/win (default options are fine),
echo then open a new PowerShell in this folder and run this again.
pause
exit /b 1

:keysstaged
git reset -q
echo Stopped: a file that looks like a key or password was about to be uploaded, so nothing was sent.
echo Add it to .gitignore and run this again.
pause
exit /b 1

:toobig
git reset -q
echo Stopped: %BIG% is over 50 MB, so nothing was sent.
echo Generated data should live in the data folder, which .gitignore skips. Move it there or add it to .gitignore.
pause
exit /b 1

:commitfailed
echo.
echo The commit didn't go through. Copy the message above into the chat and I'll sort it out.
pause
exit /b 1

:pushfailed
echo.
echo The upload didn't go through. Your commit is saved locally, so nothing is lost.
echo Copy the message above into the chat and I'll sort it out.
pause
exit /b 1
