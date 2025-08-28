`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 03:09:43 PM
// Design Name: 
// Module Name: Axi4LiteManager
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


module Axi4LiteManager # 
    (parameter C_M_AXI_ADDR_WIDTH = 8, C_M_AXI_DATA_WIDTH = 32)
    (
        // Simple Bus
        input  logic    [C_M_AXI_ADDR_WIDTH-1:0] wrAddr,
        input  logic    [C_M_AXI_DATA_WIDTH-1:0] wrData,
        input  logic    wr,
        output  logic   wrDone,
        input  logic    [C_M_AXI_ADDR_WIDTH-1:0] rdAddr,
        output logic    [C_M_AXI_DATA_WIDTH-1:0] rdData,
        input  logic    rd,
        output  logic   rdDone,
        // Axi4Lite Bus
        input  logic    M_AXI_ACLK,
        input  logic    M_AXI_ARESETN,
        output logic    [C_M_AXI_ADDR_WIDTH-1:0] M_AXI_AWADDR,
        output logic    M_AXI_AWVALID,
        input  logic    M_AXI_AWREADY,
        output logic    [C_M_AXI_DATA_WIDTH-1:0] M_AXI_WDATA,
        output logic    [3:0] M_AXI_WSTRB,
        output logic    M_AXI_WVALID,
        input  logic    M_AXI_WREADY,
        output logic    [C_M_AXI_ADDR_WIDTH-1:0] M_AXI_ARADDR,
        output logic    M_AXI_ARVALID,
        input  logic    M_AXI_ARREADY,
        input  logic    [C_M_AXI_DATA_WIDTH-1:0] M_AXI_RDATA,
        input  logic    [1:0] M_AXI_RRESP,
        input  logic    M_AXI_RVALID,
        output logic    M_AXI_RREADY,
        input  logic    [1:0] M_AXI_BRESP,
        input  logic    M_AXI_BVALID,
        output logic    M_AXI_BREADY
    );


    // FSM State
    
    typedef enum logic [3:0] {IDLE,WR1,WR2} statetype;
    
    statetype nextState, currState;
    
    //Write Flps
    
    logic [ C_M_AXI_DATA_WIDTH-1:0] wrDataD, wrDataQ;
    logic [C_M_AXI_ADDR_WIDTH-1:0] wrAddrD, wrAddrQ;
    
    always_ff @(posedge M_AXI_ACLK) begin
        if (!M_AXI_ARESETN) begin
            currState <= IDLE;
            wrDataQ <= 0;
            wrAddrQ <= 0;
        end else begin
            currState <= nextState;
            wrDataQ <= wrDataD;
            wrAddrQ <= wrAddrD;
        end
        
    end
    
    always_comb begin
        nextState = currState;
        wrDataQ = wrDataD;
        wrAddrQ = wrAddrD;
        M_AXI_AWADDR=0;
        M_AXI_AWVALID =0;
        M_AXI_WDATA =0;
        M_AXI_WVALID =0;
        case (currState) 
            IDLE: begin
                if (wr) begin
                    wrDataD = wrData;
                    wrAddrD = wrAddr;
                    nextState = WR1;
                end
            end
            WR1: begin
                M_AXI_AWADDR = wrAddrQ;
                M_AXI_AWVALID = 1;
                M_AXI_WDATA = wrDataQ;
                M_AXI_WVALID = 1;
                if (M_AXI_AWREADY && M_AXI_WREADY) begin
                    nextState = WR2;
                end
            end
            WR2: begin
            end
            default: begin
                nextState = IDLE; 
            end
        endcase
    end
    
    
    
    
    
    
endmodule
