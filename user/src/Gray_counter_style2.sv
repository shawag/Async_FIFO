`timescale 1ns / 1ps
module Gray_counter_style_2 #(
    parameter    D_WIDTH = 8
)
(
    input                   clk     ,
    input                   rst_n   ,
    input                   inc     ,
    input                   full    ,
    input                   empty   ,
    output [D_WIDTH-1:0]    addr     ,
    output [D_WIDTH:0]      ptr     
);

logic [D_WIDTH:0] bin;
logic [D_WIDTH:0] bin_nxt;
logic             inc_num;
logic [D_WIDTH:0] g_nxt;
//addr logic
assign addr = bin[D_WIDTH-1:0];
//binarty increment counter
assign inc_num = inc &((~full)|(~empty));
assign bin_nxt = bin + inc_num;

always_ff @(posedge clk, negedge rst_n) begin
    if(~rst_n)
        bin <= {D_WIDTH+1{1'b0}};
    else
        bin <= bin_nxt;
end

//binary to gray
assign g_nxt[D_WIDTH] = bin_nxt[D_WIDTH];
generate
    genvar i;
    for(i=0;i<D_WIDTH;i=i+1) begin
        assign g_nxt[i] = bin_nxt[i+1] ^ bin_nxt[i];
    end
endgenerate

always_ff @(posedge clk, negedge rst_n) begin
    if(~rst_n)
        ptr <= {D_WIDTH+1{1'b0}};
    else
        ptr <= g_nxt;
end
endmodule  //Gray_counter_style_2
