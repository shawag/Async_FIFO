`timescale 1ns / 1ps
//generate ptr with extra code in async_fifo
module Gray_counter_style_2 #(
    parameter    PTR_WIDTH = 8
)
(
    input                   clk     ,
    input                   rst_n   ,
    input                   inc     ,
    input                   full    ,
    input                   empty   ,
    output [PTR_WIDTH-2:0]  addr    ,
    output [PTR_WIDTH-1:0]  ptr     
);

logic [PTR_WIDTH-1:0] bin;
logic [PTR_WIDTH-1:0] bin_nxt;
logic             inc_num;
logic [PTR_WIDTH-1:0] g_nxt;
//addr logic
assign addr = bin[PTR_WIDTH-2:0];
//binarty increment counter
assign inc_num = inc &((~full)|(~empty));
assign bin_nxt = bin + inc_num;

always_ff @(posedge clk, negedge rst_n) begin
    if(~rst_n)
        bin <= {PTR_WIDTH{1'b0}};
    else
        bin <= bin_nxt;
end

//binary to gray
assign g_nxt[PTR_WIDTH-1] = bin_nxt[PTR_WIDTH-1];
generate
    genvar i;
    for(i=0;i<PTR_WIDTH-1;i=i+1) begin
        assign g_nxt[i] = bin_nxt[i+1] ^ bin_nxt[i];
    end
endgenerate

always_ff @(posedge clk, negedge rst_n) begin
    if(~rst_n)
        ptr <= {PTR_WIDTH{1'b0}};
    else
        ptr <= g_nxt;
end
endmodule  //Gray_counter_style_2
