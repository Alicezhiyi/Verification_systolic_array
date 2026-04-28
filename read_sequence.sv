class rd_sequence extends uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(rd_sequence)

    function new(string name = "rd_sequence");
        super.new(name);
        `uvm_info("INFO", "Constructor of rd_sequence class", UVM_NONE);
    endfunction

    task body();
        `uvm_info("INFO", "Body of rd_sequence class", UVM_NONE);
        // Implement the sequence body here
    endtask
endclass