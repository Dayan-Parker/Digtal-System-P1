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
    //Read vs Write FSM
    typedef enum logic [5:0] {IDLE, R, WR ,WR1,WR2,WRESP,RD1,RD2} statetype;

    
    statetype nextState, currState;
    
    //Write Flps
    
    logic [ C_M_AXI_DATA_WIDTH-1:0] wrDataD, wrDataQ,rdDataD, rdDataQ;
    logic [C_M_AXI_ADDR_WIDTH-1:0] wrAddrD, wrAddrQ, rdAddrD, rdAddrQ;
    
    //Create Delay 
    logic [1:0] count = 0;
    
    always_ff @(posedge M_AXI_ACLK) begin
        if (!M_AXI_ARESETN) begin
            currState <= IDLE;
            wrDataQ <= 0;
            wrAddrQ <= 0;
            rdAddrQ <= 0;
            rdDataQ <= 0;
        end else begin
            currState <= nextState;
            wrDataQ <= wrDataD;
            wrAddrQ <= wrAddrD;
            rdAddrQ <= rdAddrD;
            rdDataQ <= rdDataD;

        end
        
        //Counter increment
        if (M_AXI_WREADY) begin
            count <= count + 1;
        end
        
    end
    
    always_comb begin
        nextState = currState;
        //write
        wrDataQ = wrDataD;
        wrAddrQ = wrAddrD;
        M_AXI_AWADDR=0;
        M_AXI_AWVALID =0;
        M_AXI_WDATA =0;
        M_AXI_WVALID =0;
        M_AXI_BREADY =0;
        count = 0;

    
        //read
        M_AXI_ARADDR = rdAddrQ;
        M_AXI_RREADY =0;
        M_AXI_ARVALID =0;
        rdAddrQ = rdAddrD;
        rdDataQ = rdDataD;

        
        
        case (currState) 
            IDLE: begin
                if (wr) begin
                    wrDataD = wrData;
                    wrAddrD = wrAddr;
                    nextState = WR1;
                end
                else if (rd) begin
                    rdAddrD = rdAddrQ;
                    nextState = RD1;
                end
            end
            
            //Read
            RD1: begin
                M_AXI_ARADDR = rdAddrQ;
                M_AXI_RREADY = 1;
                M_AXI_ARVALID = 1;
                if (M_AXI_RVALID && M_AXI_ARREADY) begin
                    nextState = RD2;
                end
            end
            
            RD2: begin
                rdDataD = rdData;
                
            end
            
            
            //Write
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
                if (count >= 'h3) begin
                    M_AXI_BREADY = 1;
                    if (M_AXI_BVALID) nextState = WRESP;
                end
            end
            
            WRESP: begin
            end
            
            default: begin
                nextState = IDLE; 
            end
        endcase
    end
    
    
    
    
    
    
endmodule
