vlib work

vlog -f mstr_files.list +cover -covercells

vsim -voptargs=+acc -c work.mstr_top -cover -classdebug -uvmcontrol=all 

run 0

add wave /mstr_top/DUT/*

coverage save mstr.ucdb -onexit

run -all

quit -sim

vcover report mstr.ucdb -details -annotate -output mstr_cvg.txt

