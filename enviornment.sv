class environment extends uvm_env;
    `uvm_component_utils(environment)
    
    // Declare any necessary variables, interfaces, or components here

    // Constructor
    function new(string name = "environment", uvm_component parent);
        // Initialize any necessary components or variables here
        super.new(name, parent);
        `uvm_info("INFO", "Constructor of environment class", UVM_NONE);
    endfunction

    read_agent agt;
    scoreboard scb;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("INFO", "Build phase of environment class", UVM_NONE);
        agt = read_agent::type_id::create("agt", this);
        scb = scoreboard::type_id::create("scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("INFO", "Connect phase of environment class", UVM_NONE);
        // Connect the agent and scoreboard here
        //agt.mon.ap.connect(scb.mon_ap);
    endfunction

    // // Method to set up the environment
    // task setup();
    //     // Code to set up the environment goes here
    // endtask

    // // Method to run the test
    // task run();
    //     // Code to execute the test goes here
    // endtask

    // // Method to clean up after the test
    // task cleanup();
    //     // Code to clean up the environment goes here
    // endtask

    endclass