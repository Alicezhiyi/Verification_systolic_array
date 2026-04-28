module systolic_array #(
  parameter int DIN_WIDTH = 8,
  parameter int N         = 4
)(
  input  logic                      rst_n,
  input  logic                      clk,
  input  logic [2*DIN_WIDTH-1:0]    c_din   [0:N-1],
  input  logic [DIN_WIDTH-1:0]      a_din   [0:N-1],
  input  logic [DIN_WIDTH-1:0]      b_din   [0:N-1],
  input  logic                      in_valid,
  output logic [2*DIN_WIDTH-1:0]    c_dout  [0:N-1],
  output logic                      out_valid
);



endmodule