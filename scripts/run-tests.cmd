@echo off
rem Build the Rojo project (optional)\r
rojo.exe build -o out.rbxlx\r
rem Run TestEZ tests using rbxmk (download if needed)\r
if not exist rbxmk.exe (\r
  echo Downloading rbxmk...\r
  curl -L -o rbxmk.exe https://github.com/rojo-rbx/rbxmk/releases/download/v0.15.1/rbxmk-windows-x86_64.exe\r
)\r
rbxmk.exe test src/**/*.test.lua\r
