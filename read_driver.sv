class read_driver extends uvm_driver;
  `uvm_component_utils(read_driver)
    //virtual fifo_interface_RD vif;
    function new(string name = "read_driver", uvm_component parent);
        super.new(name, parent);
        `uvm_info("INFO", "Constructor of read_driver class", UVM_NONE);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("INFO", "Build phase of read_driver class", UVM_NONE);
        //uvm_config_db#(virtual fifo_interface_RD)::get(this, "", "vif", vif);
    endfunction

    //run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("INFO", "Run phase of read_driver class", UVM_NONE);
        `uvm_info("INFO","assign transction on interface pins", UVM_NONE);
    endtask

    // extract phase
    virtual function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info("INFO", "Extract phase of read_driver class", UVM_NONE);
        `uvm_info("INFO","Extract data from interface pins", UVM_NONE);
    endfunction
endclass
