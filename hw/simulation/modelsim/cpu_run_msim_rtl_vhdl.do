transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/siedl/Desktop/FPGA-CPU/src/ram.vhd}
vcom -93 -work work {C:/Users/siedl/Desktop/FPGA-CPU/src/io.vhd}
vcom -93 -work work {C:/Users/siedl/Desktop/FPGA-CPU/src/flash.vhd}
vcom -93 -work work {C:/Users/siedl/Desktop/FPGA-CPU/src/cpu.vhd}
vcom -93 -work work {C:/Users/siedl/Desktop/FPGA-CPU/src/alu.vhd}

