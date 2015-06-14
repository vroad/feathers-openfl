@echo off
haxe feathers-shared.hxml
if %ERRORLEVEL% neq 0 (
	exit /b
)
copy /b feathers-shared.hxml+feathers-shared.hxml.part feathers-export.hxml
haxe feathers-export.hxml