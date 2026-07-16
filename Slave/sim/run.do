vlib work

vlog -f slave_files.list +cover -covercells

vsim -voptargs=+acc work.slave_top -sv_seed random -cover -classdebug -uvmcontrol=all 

run 0

add wave /slave_top/DUT/*

coverage save slave.ucdb -onexit

run -all

quit -sim

vcover report slave.ucdb -details -annotate -output slave_cvg.txt

