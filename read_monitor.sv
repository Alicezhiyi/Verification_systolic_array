class read_monitor extends uvm_monitor;
    `uvm_component_utils(read_monitor)

    // Declare any necessary variables, interfaces, or components here

    // Constructor
    function new(string name = "read_monitor", uvm_component parent);
        // Initialize any necessary components or variables here
        super.new(name, parent);
        `uvm_info("INFO", "Constructor of read_monitor class", UVM_NONE);
    endfunction

    //phases

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("INFO", "Build phase of read_monitor class", UVM_NONE);
        // Initialize any necessary components or variables here
        //uvm_config_db#(virtual fifo_interface_RD)::get(this, "", "vif", vif);
        //`uvm_info("INFO", "get interface from confige db", UVM_NONE);
    endfunction

    //run phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("INFO", "Run phase of read_monitor class", UVM_NONE);
        `uvm_info("INFO","create transctions of packets from interface pins", UVM_NONE);
    endtask

    //extract phase
    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info("INFO", "Extract phase of read_monitor class", UVM_NONE);
        `uvm_info("INFO","Extract data from interface pins", UVM_NONE);
    endfunction

endclass