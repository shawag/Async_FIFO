`timescale 1ns / 1ps
module sync_w2r #(
    parameter    PTR_WIDTH  = 8
) 
(
    input                       rclk    ,
    input                       rrst_n  ,
    input  [PTR_WIDTH-1:0]      wptr    ,
    output [PTR_WIDTH-1:0]      rq2_wptr
);

logic   [PTR_WIDTH-1:0]     rq1_wptr;

always @(posedge rclk, negedge rrst_n) begin
    if(~rrst_n)
        {rq2_wptr,rq1_wptr} <= {(2*PTR_WIDTH-1){1'b0}};
    else
        {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
end
    
endmodule  //sync_r2w
