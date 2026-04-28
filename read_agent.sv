class read_agent extends uvm_agent;
    `uvm_component_utils(read_agent)

    // Declare any necessary variables, interfaces, or components here

    // Constructor
    function new(string name = "read_agent", uvm_component parent);
        // Initialize any necessary components or variables here
        super.new(name, parent);
        `uvm_info("INFO", "Constructor of read_agent class", UVM_NONE);
    endfunction

    //instances
    read_driver rd_drv;
    read_monitor rd_mon;
    read_sequencer rd_seqr;

    //phases

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("INFO", "Build phase of read_agent class", UVM_NONE);
        rd_drv = read_driver::type_id::create("rd_drv", this);
        rd_mon = read_monitor::type_id::create("rd_mon", this);
        rd_seqr = read_sequencer::type_id::create("rd_seqr", this);
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("INFO", "Connect phase of read_agent class", UVM_NONE);
        `uvm_info("INFO", "Connect the driver, monitor, and sequencer in read_agent class", UVM_NONE);
        //rd_drv.seq_item_port.connect(rd_seqr.seq_item_export);
    endfunction

endclass
