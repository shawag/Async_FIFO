`timescale 1ns / 1ps
module fifo1 #(
    parameter    FIFO_WIDTH  = 16,
    //set param only satisfied 2^n
    parameter    FIFO_DEPTH = 128
) 
(
    input                       wclk    ,
    input                       rclk    ,
    input                       wrst_n  ,
    input                       rrst_n  ,
    input                       winc    ,
    input                       rinc    ,
    input   [FIFO_WIDTH-1:0]    wdata   ,
    output                      wfull   ,
    output                      rempty  ,
    output  [FIFO_WIDTH-1:0]    rdata      
);

localparam  A_WIDTH = $clog2(FIFO_DEPTH);
localparam  PTR_WIDTH = A_WIDTH + 1;

logic   wren;
logic   rden;
logic   [A_WIDTH-1:0]   waddr;
logic   [A_WIDTH-1:0]   raddr;
logic   [PTR_WIDTH-1:0] wptr;
logic   [PTR_WIDTH-1:0] rptr;
logic   [PTR_WIDTH-1:0] wg_nxt;
logic   [PTR_WIDTH-1:0] rg_nxt;
logic   [PTR_WIDTH-1:0] wq2_rptr;
logic   [PTR_WIDTH-1:0] rq2_wptr;

assign  wren = winc & (~wfull);
assign  rden = rinc & (~rempty);

fifomem #(
	.D_WIDTH 	( FIFO_WIDTH  ),
	.A_WIDTH 	( A_WIDTH   ))
u_fifomem(
	.wclk  	( wclk   ),
	.rclk  	( rclk   ),
	.wen   	( wren   ),
	.ren   	( rden   ),
	.waddr 	( waddr  ),
	.raddr 	( raddr  ),
	.wdata 	( wdata  ),
	.rdata 	( rdata  )
);


Gray_counter_style_1 #(
	.PTR_WIDTH 	( PTR_WIDTH ))
u_wptr(
	.clk   	( wclk    ),
	.rst_n 	( wrst_n  ),
	.inc   	( winc    ),
	.full  	( wfull   ),
	.empty 	( rempty  ),
	.ptr   	( wptr    ),
	.addr  	( waddr   ),
	.g_nxt 	( wg_nxt  )
);



Gray_counter_style_1 #(
	.PTR_WIDTH 	( PTR_WIDTH  ))
u_rptr(
	.clk   	( rclk    ),
	.rst_n 	( rrst_n  ),
	.inc   	( rinc    ),
	.full  	( wfull   ),
	.empty 	( rempty  ),
	.ptr   	( rptr    ),
	.addr  	( raddr   ),
	.g_nxt 	( rg_nxt  )
);


wptr_full #(
	.PTR_WIDTH 	( PTR_WIDTH  ))
u_wptr_full(
	.wclk      	( wclk       ),
	.wrst_n    	( wrst_n     ),
	.wq2_rptr  	( wq2_rptr   ),
	.wgray_nxt 	( wg_nxt     ),
	.wfull     	( wfull      )
);

rptr_empty #(
	.PTR_WIDTH 	( PTR_WIDTH  ))
u_rptr_empty(
	.rclk      	( rclk       ),
	.rrst_n    	( rrst_n     ),
	.rq2_wptr  	( rq2_wptr   ),
	.rgray_nxt 	( rg_nxt     ),
	.rempty    	( rempty     )
);


sync_r2w #(
	.PTR_WIDTH 	( PTR_WIDTH  ))
u_sync_r2w(
	.wclk     	( wclk      ),
	.wrst_n   	( wrst_n    ),
	.rptr     	( rptr      ),
	.wq2_rptr 	( wq2_rptr  )
);

sync_w2r #(
	.PTR_WIDTH 	( PTR_WIDTH  ))
u_sync_w2r(
	.rclk     	( rclk      ),
	.rrst_n   	( rrst_n    ),
	.wptr     	( wptr      ),
	.rq2_wptr 	( rq2_wptr  )
);






    
endmodule  //fifo1
