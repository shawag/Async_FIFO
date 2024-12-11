`timescale 1ns / 1ps
//generate n  and n+1 gray code
module Gray_counter_style_1 #(
    parameter   D_WIDTH = 8
) 
(
    input                   clk     ,
    input                   rst_n   ,
    input                   inc     ,
    input                   full    ,
    input                   empty   ,
    output [D_WIDTH:0]      ptr     ,
    output [D_WIDTH-1:0]    addr 
);

logic [D_WIDTH:0] bin;
logic [D_WIDTH:0] bin_nxt;
logic [D_WIDTH:0] g_nxt;
logic             msb_nxt;
logic             addr_msb;
//binary increment counter
assign inc_num = inc & (~full)|(~empty);
assign bin_nxt = bin + inc_num;
//msb
assign msb_nxt = ptr[D_WIDTH] ^ ptr[D_WIDTH-1];
assign addr = {msb_nxt,ptr[D_WIDTH-2:0]};
//gray to binary
assign bin[D_WIDTH] = ptr[D_WIDTH];

generate
    genvar i;
    for(i=0; i<D_WIDTH; i=i+1) begin
        assign bin[i] = ptr[i] ^ bin[i+1];
    end
endgenerate

//binary to gray
assign g_nxt[D_WIDTH] = bin_nxt[D_WIDTH];
generate
    genvar j;
    for(j=0; j<D_WIDTH; j=j+1) begin
        assign g_nxt[j] = bin_nxt[j+1] ^ bin_nxt[j];
    end        
endgenerate

always_ff @(posedge clk ,negedge rst_n) begin
    if(~rst_n)
        ptr <= {D_WIDTH+1{1'b0}};
    else
        ptr <= g_nxt;
end

always_ff @(posedge clk, negedge rst_n) begin
    if(~rst_n)
        addr_msb <= 1'b0;
    else
        addr_msb <= msb_nxt;
end

endmodule //Gray_counter_style_1
