`timescale 1ns / 1ps
//generate full signal in write clock domain
module wptr_full #(
    parameter    PTR_WIDTH = 8
) 
(
    input                       wclk        ,
    input                       wrst_n      ,
    input  [PTR_WIDTH-1:0]      wq2_rptr    ,
    input  [PTR_WIDTH-1:0]      wgray_nxt   ,
    output                      wfull
);

logic   wfull_val;

assign wfull_val = (wgray_nxt=={~wq2_rptr[PTR_WIDTH-1,PTR_WIDTH-2],wq2_rptr[PTR_WIDTH-3,0]});

always_ff @(posedge wclk, negedge wrst_n) begin
    if(~wrst_n)
        wfull <= 1'b0;
    else
        wfull <= wfull_val;
end
   
endmodule  //wptr_full
