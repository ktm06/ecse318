onerror {quit -f}
vlib work
vcom tag_ram.vhd data_ram.vhd cache_control.vhd cache.vhd main_memory.vhd system_tb.vhd
vsim -voptargs=+acc -t 1ns work.system_tb
run -all
quit -f
