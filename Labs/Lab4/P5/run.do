vlib work
vcom tag_ram.vhd data_ram.vhd cache_control.vhd cache.vhd main_memory.vhd system_tb.vhd
vsim -voptargs=+acc -t 1ns work.system_tb
add wave /system_tb/clk /system_tb/reset
add wave /system_tb/Pstrobe /system_tb/Prw
add wave -radix hex /system_tb/Paddr /system_tb/Pdata
add wave /system_tb/Pready
add wave /system_tb/u_cache/u_ctrl/state /system_tb/u_cache/u_ctrl/cnt /system_tb/u_cache/hit /system_tb/u_cache/ram_we
add wave /system_tb/Sysstrobe /system_tb/Sysrw
add wave -radix hex /system_tb/Sysaddress /system_tb/Sysdata
run -all
wave zoom full
