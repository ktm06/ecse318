@echo off
cd /d "%~dp0"
"C:\intelFPGA\20.1\modelsim_ase\win32aloem\vsim.exe" -c -do run_batch.do > modelsim_log.txt 2>&1
