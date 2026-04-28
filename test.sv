class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    function new(string name="fifo_test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("INFO","Constructor of test class", UVM_NONE);
    endfunction

    environment env;
    rd_sequence seq;
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("INFO","Build phase of test class", UVM_NONE);
        env = environment::type_id::create("env", this);
        seq = rd_sequence::type_id::create("seq");
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("INFO","End of elaboration phase of test class", UVM_NONE);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("INFO","Run phase of test class", UVM_NONE);
        `uvm_info("INFO","Start the test", UVM_NONE);

        phase.raise_objection(this);
        $display("%0t: Start of the sequence...", $time);
        seq.start(env.agt.rd_seqr);
        phase.drop_objection(this);
        $display("%0t: End of the sequence...", $time);
    endtask
endclass