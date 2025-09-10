`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 01:36:23 PM
// Design Name: 
// Module Name: Axi4LiteSupporter
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


module Axi4LiteSupporter # 
    (parameter C_S_AXI_ADDR_WIDTH = 6, C_S_AXI_DATA_WIDTH = 32)
    (
        // Simple Bus
        output logic  [C_S_AXI_ADDR_WIDTH-1:0] wrAddr,
        output logic  [C_S_AXI_DATA_WIDTH-1:0] wrData,
        output logic  wr,
        output logic  [C_S_AXI_ADDR_WIDTH-1:0] rdAddr,
        input  logic  [C_S_AXI_DATA_WIDTH-1:0] rdData,
        output logic  rd,
        // Axi4Lite Bus
        input  logic  S_AXI_ACLK,
        input  logic  S_AXI_ARESETN,
        input  logic  [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
        input  logic  S_AXI_AWVALID,
        output logic  S_AXI_AWREADY,
        input  logic  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
        input  logic  [3:0] S_AXI_WSTRB,
        input  logic  S_AXI_WVALID,
        output logic  S_AXI_WREADY,
        input  logic  [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
        input  logic  S_AXI_ARVALID,
        output logic  S_AXI_ARREADY,
        output logic  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
        output logic  [1:0] S_AXI_RRESP,
        output logic  S_AXI_RVALID,
        input  logic  S_AXI_RREADY,
        output logic  [1:0] S_AXI_BRESP,
        output logic  S_AXI_BVALID,
        input  logic  S_AXI_BREADY
    );

// FSM State
    // Read vs. Write FSM
    typedef enum logic [5:0] {IDLE, WR1, WR2, RD1, RD2} statetype;
    
    statetype currState, nextState;
    
    //Write & Read Flops
    
//    logic [C_S_AXI_DATA_WIDTH-1:0] wrDataD, wrDataQ,rdDataD, rdDataQ;
//    logic [C_S_AXI_ADDR_WIDTH-1:0] wrAddrD, wrAddrQ, rdAddrD, rdAddrQ;
    
//    assign rdData = rdDataQ;

    always_ff @(posedge S_AXI_ACLK) begin
    
        if (!S_AXI_ARESETN) begin
            currState <= IDLE;
//            wrDataQ <= 0;
//            wrAddrQ <= 0;
//            rdAddrQ <= 0;
//            rdDataQ <= 0;
        end else begin
            currState <= nextState;
//            wrDataQ <= wrDataD;
//            wrAddrQ <= wrAddrD;
//            rdAddrQ <= rdAddrD;
//            rdDataQ <= rdDataD;
        end
        
    end
    
    always_comb begin
        nextState = currState;
        
        // Write
//        wrDataD = wrDataQ;
//        wrAddrD = wrAddrQ;
        wrAddr = 0;
        wrData = 0;
        S_AXI_AWREADY = 0;
        S_AXI_WREADY = 0;
        S_AXI_BVALID = 0;
        
        // Read
//        rdAddrD = rdAddrQ;
//        rdDataD = rdDataQ;
        rdAddr = 0;
        S_AXI_RDATA = 0;    
        S_AXI_ARREADY = 0;
        S_AXI_RDATA = 0;
        S_AXI_RVALID = 0;
        S_AXI_BRESP = 0;
        S_AXI_RRESP = 0;
        wr = 0;
        rd = 0;
        
        case(currState)
            IDLE: begin
                if (S_AXI_WVALID == 1 && S_AXI_AWVALID == 1) begin
//                    wrDataD = wrData;
//                    wrAddrD = wrAddr;
                    wrAddr = S_AXI_AWADDR;
                    wrData = S_AXI_WDATA;
                    S_AXI_AWREADY = 1;
                    S_AXI_WREADY = 1;
                    wr = 1;
                    nextState = WR1;
                end
                else if (S_AXI_ARVALID == 1) begin
                    rd=1;
//                    rdAddrD = rdAddrQ;
                    rdAddr = S_AXI_ARADDR;
                    S_AXI_RDATA = rdData;
                    nextState = RD1;
                end
            end
            
            // Write
            WR1: begin
                S_AXI_BVALID = 1; 
                if (S_AXI_BREADY == 1) begin
                    nextState = WR2;
                end
            end
            
            WR2: begin
                 S_AXI_BRESP = 0;
                 nextState = IDLE;
            end
            
            // Read
            
            RD1: begin
                S_AXI_ARREADY = 1;
                S_AXI_RVALID = 1;
                S_AXI_RRESP = 0;
                if (S_AXI_RREADY == 1) begin
                    nextState = RD2;
                end
            end
            
            RD2: begin
                nextState = IDLE;
            end
            
            default: begin
                nextState = IDLE;
            end
        endcase
        
    end

endmodule
