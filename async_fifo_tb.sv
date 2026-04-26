module async_fifo_tb;
parameter int BUS_WIDTH = 8;
parameter int COUNTER_WIDTH = 4;

logic clk_write;
logic rst_write_n;
logic write_en;
logic [BUS_WIDTH-1:0] data_in;
logic full;

logic clk_read;
logic rst_read_n;
logic read_en;
logic [BUS_WIDTH-1:0] data_out;
logic empty;

async_fifo #(
    .BUS_WIDTH(BUS_WIDTH),
    .COUNTER_WIDTH(COUNTER_WIDTH)
) dut (
    .clk_write(clk_write),
    .rst_write_n(rst_write_n),
    .write_en(write_en),
    .data_in(data_in),
    .full(full),

    .clk_read(clk_read),
    .rst_read_n(rst_read_n),
    .read_en(read_en),
    .data_out(data_out),
    .empty(empty)
);

//=======version 1=======
// // Generate write clock
// initial clk_write = 0;
// always #5 clk_write = ~clk_write;

// initial clk_read = 0;
// always #7 clk_read = ~clk_read;

// initial begin
//     // Initialize signals
//     clk_write = 0;
//     rst_write_n = 0;
//     write_en = 0;
//     data_in = 0;

//     clk_read = 0;
//     rst_read_n = 0;
//     read_en = 0;

//     // Reset the FIFO
//     #20 
//     rst_write_n = 1;
//     rst_read_n = 1;
    

//     // Write some data into the FIFO
//     for (int i = 0; i < 32; i++) begin
//         @(posedge clk_write);
//         write_en <= 1;
//         data_in <= i;
//     end
//     write_en <= 0;

//     // Read the data back from the FIFO
//     for (int i = 0; i < 32; i++) begin
//         @(posedge clk_read);
//         read_en <= 1;
//         @(posedge clk_read);
//         read_en <= 0;
//         $display("Read data: %d", data_out);
//     end

//     $finish;
// end

//=======version 2=======
// Generate write clock
initial clk_write = 0;
always #5 clk_write = ~clk_write;

initial clk_read = 0;
always #7 clk_read = ~clk_read;

logic [BUS_WIDTH-1:0] q;

localparam int DEPTH = 1 << COUNTER_WIDTH;

task automatic write_data(input logic [BUS_WIDTH-1:0] d);
    begin
        @(negedge clk_write);
        data_in = d;
        write_en = 1;
        @(posedge clk_write);
        #1;
        write_en = 0;
    end
endtask

task automatic read_data(output logic [BUS_WIDTH-1:0] d);
    begin
        @(negedge clk_read);
        read_en = 1;
        @(posedge clk_read);
        #1;
        read_en = 0;
        d = data_out;
    end
endtask

initial begin
    rst_write_n = 0;
    rst_read_n = 0;
    write_en = 0;
    read_en = 0;
    data_in = 0;

    repeat (2) @(posedge clk_write);
    repeat (2) @(posedge clk_read);
    rst_write_n = 1;
    rst_read_n = 1;

    repeat (3) @(posedge clk_read);

    // 1) after reset empty=1, full=0
    assert (empty === 1'b1) else $fatal("RESET: empty should be 1");
    assert (full  === 1'b0) else $fatal("RESET: full should be 0");

    // 2) write until full
    for (int i = 0; i < DEPTH; i++) write_data(i[BUS_WIDTH-1:0]);
    repeat (3) @(posedge clk_write);
    assert (full  === 1'b1) else $fatal("After writing DEPTH elements, full should be 1");

    // 3) write after full
    for (int i = 0; i < 4; i++) write_data((8'hA0 + i));

    // 4) read one, full should be set back to 0
    read_data(q);
    repeat (3) @(posedge clk_write);
    assert (full === 1'b0) else $fatal("FULL: should deassert after one read and sync");

    // 5) read until empty
    for (int i = 1; i < DEPTH; i++) begin
        read_data(q);
        assert (q == i[BUS_WIDTH-1:0])
          else $fatal("DATA MISMATCH: exp=%0d got=%0d", i, q);
    end
    repeat (3) @(posedge clk_read);
    assert (empty === 1'b1) else $fatal("EMPTY: not asserted after draining");

    // 6) read after empty
    for (int i = 0; i < 3; i++) begin
        read_data(q);
        assert (empty === 1'b1) else $fatal("UNDERFLOW: empty dropped unexpectedly");
    end

    $display("PASS: full/empty logic checked.");
    $finish;
end


endmodule