`timescale 1ns / 1ps
module fifomem #(
    parameter    D_WIDTH  = 32  ,
    parameter    A_WIDTH  = 8
) 
(
    input                   wclk        ,
    input                   rclk        ,
    input                   wen         ,
    input                   ren         ,
    input   [A_WIDTH-1:0]   waddr       ,
    input   [A_WIDTH-1:0]   raddr       ,
    output  [D_WIDTH-1:0]   wdata       ,
    output  [D_WIDTH-1:0]   rdata
);

localparam  D_DEPTH = 1 >> A_WIDTH;

logic   [D_WIDTH-1:0]   ram     [0:D_DEPTH-1];

always_ff @(posedge wclk) begin
    if(wen)
        ram[waddr] <= wdata;
end

always_ff @(posedge rclk) begin
    if(rden)
        rdata <= ram[raddr];
    else
        raddr <= raddr;
end
    
endmodule  //fifomem
