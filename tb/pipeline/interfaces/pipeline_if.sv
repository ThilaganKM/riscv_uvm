interface pipeline_if(input logic clk);

  logic        commit_valid;
  logic [31:0] commit_pc;
  logic [4:0]  commit_rd;
  logic [31:0] commit_data;

endinterface