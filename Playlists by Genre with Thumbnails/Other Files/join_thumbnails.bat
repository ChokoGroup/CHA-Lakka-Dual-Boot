@echo off
echo Run from Named_Titles2
pause
md ..\Named_Titles
for %%i in (*.png) do magick "%%i" \CHA_LAKKA\margin.png "..\Named_Snaps\%%i" -append "..\Named_Titles\%%i"
