`timescale 1ns / 1ps
//generate empty signal in read clock domain
module rptr_empty #(
    parameter  PTR_WIDTH = 8
) 
(
    input                       rclk        ,
    input                       rrst_n      ,
    input [PTR_WIDTH-1:0]       rq2_wptr    ,
    input [PTR_WIDTH-1:0]       rgray_nxt   ,
    output                      rempty   
);

logic   rempty_val;

assign rempty_val = (rq2_wptr==rgray_nxt);

always_ff @(posedge rclk, negedge rrst_n) begin
    if(~rrst_n)
        rempty <= 1'b1;
    else
        rempty <= rempty_val;
end
    
endmodule