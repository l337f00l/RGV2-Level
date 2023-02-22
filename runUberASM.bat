@echo off 
cd /d "%~dp0"

start /b /wait /d "Programs and Tools\UberASM" UberASM.exe "list.txt"
@pause