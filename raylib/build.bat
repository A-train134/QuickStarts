@echo off
setlocal

REM windres ".\resources\app.rc" ".\build-out\app.res" || exit /b 1
REM build-out\app.res
robocopy resources .build-out\resources /E
zig c++  .\src\main.cpp  -o .\.build-out\main.exe -I"..\raylib\include" "..\raylib\zig-out\lib\raylib.lib" -lopengl32 -lgdi32 -lwinmm || exit /b 1
.\.build-out\main.exe
