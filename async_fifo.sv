module async_fifo #(
    parameter int BUS_WIDTH = 8,
    parameter int COUNTER_WIDTH = 4
)

(
    input logic clk_write,
    input logic rst_write_n,
    input logic write_en,
    input logic [BUS_WIDTH-1:0] data_in,
    output logic full,

    input logic clk_read,
    input logic rst_read_n,
    input logic read_en,
    output logic [BUS_WIDTH-1:0] data_out,
    output logic empty
);

localparam DEPTH = 1 << COUNTER_WIDTH;

logic [BUS_WIDTH-1:0] fifo_mem [0:DEPTH-1];
logic [COUNTER_WIDTH:0] write_ptr, read_ptr;
logic [COUNTER_WIDTH:0] write_ptr_sync0, read_ptr_sync0;
logic [COUNTER_WIDTH:0] write_ptr_sync1, read_ptr_sync1;

// Write logic
always_ff @(posedge clk_write or negedge rst_write_n) begin
    if (!rst_write_n) begin
        write_ptr <= 0;
    end else if (write_en && !full) begin
        fifo_mem[write_ptr] <= data_in;
        write_ptr <= write_ptr + 1;
        
    end
end

// Read logic
always_ff @(posedge clk_read or negedge rst_read_n) begin
    if (!rst_read_n) begin
        read_ptr <= 0;
    end else if (read_en && !empty) begin
        data_out <= fifo_mem[read_ptr];
        read_ptr <= read_ptr + 1;
    end
end 

// Synchronize pointers
always_ff @(posedge clk_write or negedge rst_write_n) begin
    if (!rst_write_n) begin
        read_ptr_sync0 <= 0;
        read_ptr_sync1 <= 0;
    end else begin
        read_ptr_sync0 <= read_ptr;
        read_ptr_sync1 <= read_ptr_sync0;
    end
end

always_ff @(posedge clk_read or negedge rst_read_n) begin
    if (!rst_read_n) begin
        write_ptr_sync0 <= 0;
        write_ptr_sync1 <= 0;
    end else begin
        write_ptr_sync0 <= write_ptr;
        write_ptr_sync1 <= write_ptr_sync0;
    end
end

// Full and empty logic
assign full = (write_ptr_sync0 == {~read_ptr_sync1[COUNTER_WIDTH], read_ptr_sync1[COUNTER_WIDTH-1:0]});
assign empty = (read_ptr_sync0 == write_ptr_sync1);

endmodule