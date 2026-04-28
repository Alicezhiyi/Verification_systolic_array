module sub_sys #(
  parameter int DIN_WIDTH = 8,
  parameter int N         = 4,
  parameter int BUS_WIDTH = 2*DIN_WIDTH*N
)(
  input  logic                  rst_n,
  input  logic                  sys_clk,
  input  logic                  sr_clk,
  input  logic [7:0]            M_minus_one,
  input  logic [BUS_WIDTH-1:0]  din,
  input  logic                  wr_fifo,
  input  logic                  rd_fifo,
  output logic                  in_fifo_full,
  output logic [BUS_WIDTH-1:0]  dout,
  output logic                  out_fifo_empty
);
    typedef logic signed [DIN_WIDTH-1:0]   din_t;
    typedef logic signed [2*DIN_WIDTH-1:0] acc_t;
    localparam int COUNTER_WIDTH = 4;

    logic                   in_fifo_empty;
    logic [BUS_WIDTH-1:0]   sa_in_sample;
    
    // Input FIFO (sys_clk write, sr_clk read)
    async_fifo #(
        .BUS_WIDTH(BUS_WIDTH),
        .COUNTER_WIDTH(COUNTER_WIDTH)
    ) input_fifo (
        .clk_write(sys_clk),
        .rst_write_n(rst_n),
        .write_en(wr_fifo),
        .data_in(din),
        .full(in_fifo_full),

        .clk_read(sr_clk),
        .rst_read_n(rst_n),
        .read_en(1'b1), // Always read when not empty
        .data_out(sa_in_sample),
        .empty(in_fifo_empty)
    );

    // Systolic array instance (sr_clk domain)
    logic [DIN_WIDTH-1:0]       a_din [0:N-1];
    logic [DIN_WIDTH-1:0]       b_din [0:N-1];
    logic [2*DIN_WIDTH-1:0]     c_din [0:N-1];
    logic [2*DIN_WIDTH-1:0]     c_dout[0:N-1];
    logic                       in_valid, out_valid;

    systolic_array #(
        .DIN_WIDTH(DIN_WIDTH),
        .N(N)
    ) sa (
        .rst_n(rst_n),
        .clk(sr_clk),
        .c_din(c_din),
        .a_din(a_din),
        .b_din(b_din),
        .in_valid(in_valid),
        .c_dout(c_dout),
        .out_valid(out_valid)
    );


    always_ff @(posedge sr_clk or negedge rst_n) begin
        if (!rst_n) begin
        in_valid <= 0;
        end else begin
        in_valid <= 0;
        if (!in_fifo_empty) begin
            for (int i = 0; i < N; i++) begin
            a_din[i] <= sa_in_sample[i*DIN_WIDTH +: DIN_WIDTH];
            b_din[i] <= sa_in_sample[(N+i)*DIN_WIDTH +: DIN_WIDTH];
            end
            in_valid <= 1;
        end
        end
    end

    logic out_fifo_full;
    logic sa_out_sample;

    always_ff @(posedge sr_clk or negedge rst_n) begin
        if (!rst_n) begin
            out_valid <= 0;
        end else begin
            out_valid <= 0;
            if(!out_fifo_full) begin
                for (int i = 0; i < N; i++) begin
                    sa_out_sample[i*2*DIN_WIDTH +: 2*DIN_WIDTH] = c_dout[i];
                end
            end
        end
    end

    // Output FIFO (sr_clk write, sys_clk read)
    async_fifo #(
        .BUS_WIDTH(BUS_WIDTH),
        .COUNTER_WIDTH(COUNTER_WIDTH)
    ) output_fifo (
        .clk_write(sr_clk),
        .rst_write_n(rst_n),
        .write_en(out_valid),  
        .data_in(sa_out_sample), // Concatenate outputs
        .full(out_fifo_full),
        .clk_read(sys_clk),
        .rst_read_n(rst_n),
        .read_en(rd_fifo),  
        .data_out(dout),
        .empty(out_fifo_empty)
    );



endmodule