`include "test_pkg.sv"
//`include interface

module top;
    //interface
    //DUT instantiation
    initial begin
        `uvm_info("INFO",".................", UVM_NONE);
        `uvm_info("INFO",".................", UVM_NONE);

        `uvm_info("INFO","TestBench top initial block, set interface in config db", UVM_NONE);
        `uvm_info("INFO","Call run_test", UVM_NONE);

        run_test("fifo_test");
    end

    //initial begin
    //set interface in config db, virtual interface, to get access in dynamic objects
    //uvm_config_db#(virtual async_fifo_if)::set(null, "*", "vif", fifo_if);
    //end
endmodule