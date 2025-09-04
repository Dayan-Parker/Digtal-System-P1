`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 02:54:27 PM
// Design Name: 
// Module Name: Axi4LiteRegs
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Axi4LiteRegs (
  input  logic CLK,
  input  logic enable,
  input  logic reset_n,
  input  logic [5:0]  Addr,
  input  logic [31:0] DataIn,
  output logic [31:0] DataOut
);

  logic [31:0] reg0Q, reg1Q, reg0D, reg1D;

  // Registers
  always_ff @(posedge CLK or negedge reset_n) begin
    if (!reset_n) begin
      reg0Q <= '0;
      reg1Q <= '0;
    end else begin
      reg0Q <= reg0D;
      reg1Q <= reg1D;
    end
  end

  // Next-state and read mux
  always_comb begin
    // Hold by default
    reg0D   = reg0Q;
    reg1D   = reg1Q;

    unique case (Addr)
      6'd0:    DataOut = reg0Q;
      6'd1:    DataOut = reg1Q;
      default: DataOut = '0;
    endcase

    // Writes gated by enable
    if (enable) begin
      unique case (Addr)
        6'd0:    reg0D = DataIn;
        6'd1:    reg1D = DataIn;
        default:;
      endcase
    end
  end

endmodule
