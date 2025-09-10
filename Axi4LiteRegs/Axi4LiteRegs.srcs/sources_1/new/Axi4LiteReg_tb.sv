`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 03:31:50 PM
// Design Name: 
// Module Name: Axi4LiteReg_tb
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


module Axi4LiteReg_tb ();


////////////////////////////////////////////////////////////////
// Axi4Lite Manager instantiation    
////////////////////////////////////////////////////////////////
parameter C_S_AXI_ADDR_WIDTH = 4, C_S_AXI_DATA_WIDTH = 32, CLK_PERIOD = 33.33 ;

// Axi4Lite signals
logic   S_AXI_ACLK ;
logic   S_AXI_ARESETN ;
logic   [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR ;
logic   S_AXI_AWVALID ;
logic   S_AXI_AWREADY ;
logic   [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA ;
logic   [3:0] S_AXI_WSTRB ;
logic   S_AXI_WVALID ;
logic   S_AXI_WREADY ;
logic   [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR ;
logic   S_AXI_ARVALID ;
logic   S_AXI_ARREADY ;
logic   [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA ;
logic   [1:0] S_AXI_RRESP ;
logic   S_AXI_RVALID ;
logic   S_AXI_RREADY ;
logic   [1:0] S_AXI_BRESP ;
logic   S_AXI_BVALID ;
logic   S_AXI_BREADY ;
// Simple Bus signals
logic   [C_S_AXI_ADDR_WIDTH-1:0]    wrAddrM;
logic   [C_S_AXI_DATA_WIDTH-1:0]    wrDataM;
logic                               wrM ;
logic                               wrDoneM;
logic   [C_S_AXI_ADDR_WIDTH-1:0]    rdAddrM ;
logic   [C_S_AXI_DATA_WIDTH-1:0]    rdDataM;
logic                               rdM;
logic                               rdDoneM;

Axi4LiteManager #(.C_M_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH), .C_M_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteManager1
        (
            // Simple Bus
            .wrAddr(wrAddrM),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
            .wrData(wrDataM),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
            .wr(wrM),                            // input    
            .wrDone(wrDoneM),                    // output
            .rdAddr(rdAddrM),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
            .rdData(rdDataM),                    // output   [C_M_AXI_DATA_WIDTH-1:0]
            .rd(rdM),                            // input
            .rdDone(rdDoneM),                    // output
            // Axi4Lite Bus
            .M_AXI_ACLK(S_AXI_ACLK),            // input
            .M_AXI_ARESETN(S_AXI_ARESETN),      // input
            .M_AXI_AWADDR(S_AXI_AWADDR),        // output   [C_M_AXI_ADDR_WIDTH-1:0] 
            .M_AXI_AWVALID(S_AXI_AWVALID),      // output
            .M_AXI_AWREADY(S_AXI_AWREADY),      // input
            .M_AXI_WDATA(S_AXI_WDATA),          // output   [C_M_AXI_DATA_WIDTH-1:0]
            .M_AXI_WSTRB(S_AXI_WSTRB),          // output   [3:0]
            .M_AXI_WVALID(S_AXI_WVALID),        // output
            .M_AXI_WREADY(S_AXI_WREADY),        // input
            .M_AXI_ARADDR(S_AXI_ARADDR),        // output   [C_M_AXI_ADDR_WIDTH-1:0]
            .M_AXI_ARVALID(S_AXI_ARVALID),      // output
            .M_AXI_ARREADY(S_AXI_ARREADY),      // input
            .M_AXI_RDATA(S_AXI_RDATA),          // input    [C_M_AXI_DATA_WIDTH-1:0]
            .M_AXI_RRESP(S_AXI_RRESP),          // input    [1:0]
            .M_AXI_RVALID(S_AXI_RVALID),        // input
            .M_AXI_RREADY(S_AXI_RREADY),        // output
            .M_AXI_BRESP(S_AXI_BRESP),          // input    [1:0]
            .M_AXI_BVALID(S_AXI_BVALID),        // input
            .M_AXI_BREADY(S_AXI_BREADY)         // output
        );
        
 
Axi4LiteRegs #(.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteRegs (
        .CLK(S_AXI_ACLK),
        .reset_n(S_AXI_ARESETN),
        // Axi4Lite Bus
        .S_AXI_ACLK(S_AXI_ACLK),            // input
        .S_AXI_ARESETN(S_AXI_ARESETN),      // input
        .S_AXI_AWADDR(S_AXI_AWADDR),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_AWVALID(S_AXI_AWVALID),      // input
        .S_AXI_AWREADY(S_AXI_AWREADY),      // output
        .S_AXI_WDATA(S_AXI_WDATA),          // input    [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_WSTRB(S_AXI_WSTRB),          // input    [3:0]
        .S_AXI_WVALID(S_AXI_WVALID),        // input
        .S_AXI_WREADY(S_AXI_WREADY),        // output        
        .S_AXI_ARADDR(S_AXI_ARADDR),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_ARVALID(S_AXI_ARVALID),      // input
        .S_AXI_ARREADY(S_AXI_ARREADY),      // output
        .S_AXI_RDATA(S_AXI_RDATA),          // output   [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_RRESP(S_AXI_RRESP),          // output   [1:0]
        .S_AXI_RVALID(S_AXI_RVALID),        // output    
        .S_AXI_RREADY(S_AXI_RREADY),        // input
        .S_AXI_BRESP(S_AXI_BRESP),          // output   [1:0]
        .S_AXI_BVALID(S_AXI_BVALID),        // output
        .S_AXI_BREADY(S_AXI_BREADY)         // input
        ) ; 

parameter CLK_PERIOD_2 = (CLK_PERIOD)/2;

always begin
    # (CLK_PERIOD_2) S_AXI_ACLK = ~S_AXI_ACLK;
end 


initial begin
    S_AXI_WSTRB = 4'b1111;
    S_AXI_ARESETN =0;
    S_AXI_ACLK = 0;
    wrM=0;
    wrAddrM = 0;
    wrDataM = 0;
    rdAddrM = 0;
    rdM = 0;
    
    //Generate Reset
    #(CLK_PERIOD_2 +2) S_AXI_ARESETN = 1;
    #(CLK_PERIOD*7);
    
    //write cycle to Adrres 0
    wrAddrM = 0;
    wrDataM = 32'hdeadbeef;
    wrM =1;
    #(CLK_PERIOD)
    wrAddrM = 0;
    wrDataM = 0;
    wrM = 0;
    
    #(CLK_PERIOD*10)
    
    //read cycle to Adress 0
    rdAddrM = 0;
    rdM = 1;
    #(CLK_PERIOD)
    rdAddrM = 0;
    rdM = 0;
    
    #(CLK_PERIOD*7);
    $stop;
end

endmodule
