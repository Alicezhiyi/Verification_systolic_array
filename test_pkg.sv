package test_pkg;
    `include "uvm_macros.svh" // contains all uvm macros
    import uvm_pkg::*; // contains all uvm base classes

    //include classes in order
    `include "read_sequence.sv"
    `include "read_sequencer.sv"
    `include "read_driver.sv"
    `include "read_monitor.sv"
    `include "read_agent.sv"
    `include "scoreboard.sv"
    `include "enviornment.sv"
    `include "test.sv"

endpackage

