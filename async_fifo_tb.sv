module async_fifo_tb;
parameter int BUS_WIDTH = 8;
parameter int COUNTER_WIDTH = 4;

logic wclk;
logic wrst_n;
logic write_en;
logic [BUS_WIDTH-1:0] wdata;
logic full;

logic rclk;
logic rrst_n;
logic read_en;
logic [BUS_WIDTH-1:0] rdata;
logic empty;

async_fifo #(
    .DSIZE(BUS_WIDTH),
    .ASIZE(COUNTER_WIDTH),
    .FALLTHROUGH("FALSE")
) dut (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .winc(write_en),
    .wdata(wdata),
    .wfull(full),

    .rclk(rclk),
    .rrst_n(rrst_n),
    .rinc(read_en),
    .rdata(rdata),
    .rempty(empty)
);

//=======version 1=======
// // Generate write clock
// initial wclk = 0;
// always #5 wclk = ~wclk;

// initial rclk = 0;
// always #7 rclk = ~rclk;

// initial begin
//     // Initialize signals
//     wclk = 0;
//     wrst_n = 0;
//     write_en = 0;
//     wdata = 0;

//     rclk = 0;
//     rrst_n = 0;
//     read_en = 0;

//     // Reset the FIFO
//     #20 
//     wrst_n = 1;
//     rrst_n = 1;
    

//     // Write some data into the FIFO
//     for (int i = 0; i < 32; i++) begin
//         @(posedge wclk);
//         write_en <= 1;
//         wdata <= i;
//     end
//     write_en <= 0;

//     // Read the data back from the FIFO
//     for (int i = 0; i < 32; i++) begin
//         @(posedge rclk);
//         read_en <= 1;
//         @(posedge rclk);
//         read_en <= 0;
//         $display("Read data: %d", rdata);
//     end

//     $finish;
// end

//=======version 2=======
// Generate write clock
initial wclk = 0;
always #5 wclk = ~wclk;

initial rclk = 0;
always #7 rclk = ~rclk;

logic [BUS_WIDTH-1:0] q;

localparam int DEPTH = 1 << COUNTER_WIDTH;

task automatic write_data(input logic [BUS_WIDTH-1:0] d);
    begin
        @(negedge wclk);
        wdata = d;
        write_en = 1;
        @(posedge wclk);
        #1;
        write_en = 0;
    end
endtask

task automatic read_data(output logic [BUS_WIDTH-1:0] d);
    begin
        @(negedge rclk);
        read_en = 1;
        @(posedge rclk);
        #1;
        read_en = 0;
        d = rdata;
    end
endtask

initial begin
    wrst_n = 0;
    rrst_n = 0;
    write_en = 0;
    read_en = 0;
    wdata = 0;

    repeat (2) @(posedge wclk);
    repeat (2) @(posedge rclk);
    wrst_n = 1;
    rrst_n = 1;

    repeat (3) @(posedge rclk);

    // 1) after reset empty=1, full=0
    assert (empty === 1'b1) else $fatal("RESET: empty should be 1");
    assert (full  === 1'b0) else $fatal("RESET: full should be 0");

    // 2) write until full
    for (int i = 0; i < DEPTH; i++) write_data(i[BUS_WIDTH-1:0]);
    repeat (3) @(posedge wclk);
    assert (full  === 1'b1) else $fatal("After writing DEPTH elements, full should be 1");

    // 3) write after full
    for (int i = 0; i < 4; i++) write_data((8'hA0 + i));

    // 4) read one, full should be set back to 0
    read_data(q);
    repeat (4) @(posedge wclk);
    assert (full === 1'b0) else $fatal("FULL: should deassert after one read and sync");

    // 5) read until empty
    for (int i = 1; i < DEPTH; i++) begin
        read_data(q);
        assert (q == i[BUS_WIDTH-1:0])
          else $fatal("DATA MISMATCH: exp=%0d got=%0d", i, q);
    end
    repeat (3) @(posedge rclk);
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