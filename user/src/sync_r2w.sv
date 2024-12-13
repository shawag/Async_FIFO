`timescale 1ns / 1ps
module sync_r2w #(
    parameter    PTR_WIDTH  = 8
) 
(
    input                       wclk    ,
    input                       wrst_n  ,
    input  [PTR_WIDTH-1:0]      rptr    ,
    output [PTR_WIDTH-1:0]      wq2_rptr
);

logic   [PTR_WIDTH-1:0]     wq1_rptr;

always @(posedge wclk, negedge wrst_n) begin
    if(~wrst_n)
        {wq2_rptr,wq1_rptr} <= {(2*PTR_WIDTH-1){1'b0}};
    else
        {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
end
    
endmodule  //sync_r2w
