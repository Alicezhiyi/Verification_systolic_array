export DISPLAY=mario.ece.utexas.edu:125.0
vcs -full64 -top async_fifo_tb -f ./filelist.f -o async_fifo_tb_o -lelf -xlrm uniq_prior_final -kdb -timescale=1ns/1ps -debug_all -sverilog
./async_fifo_tb_o -verdi &