class read_sequencer extends uvm_sequencer;
    `uvm_component_utils(read_sequencer)

    // Declare any necessary variables, interfaces, or components here

    // Constructor
    function new(string name = "read_sequencer", uvm_component parent);
        // Initialize any necessary components or variables here
        super.new(name, parent);
        `uvm_info("INFO", "Constructor of read_sequencer class", UVM_NONE);
    endfunction

endclass