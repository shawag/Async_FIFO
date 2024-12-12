`timescale 1ns / 1ps
//generate ptr with extra code in async_fifo
module Gray_counter_style_1 #(
    parameter   PTR_WIDTH = 8
) 
(
    input                       clk     ,
    input                       rst_n   ,
    input                       inc     ,
    input                       full    ,
    input                       empty   ,
    output [PTR_WIDTH-1:0]      ptr     ,
    output [PTR_WIDTH-2:0]      addr 
);

logic [PTR_WIDTH-1:0] bin;
logic [PTR_WIDTH-1:0] bin_nxt;
logic [PTR_WIDTH-1:0] g_nxt;
logic             msb_nxt;
logic             addr_msb;
//binary increment counter
assign inc_num = inc & (~full)|(~empty);
assign bin_nxt = bin + inc_num;
//msb
assign msb_nxt = ptr[PTR_WIDTH-1] ^ ptr[PTR_WIDTH-2];
assign addr = {msb_nxt,ptr[PTR_WIDTH-3:0]};
//gray to binary
assign bin[PTR_WIDTH-1] = ptr[PTR_WIDTH-1];

generate
    genvar i;
    for(i=0; i<PTR_WIDTH-1; i=i+1) begin
        assign bin[i] = ptr[i] ^ bin[i+1];
    end
endgenerate

//binary to gray
assign g_nxt[PTR_WIDTH-1] = bin_nxt[PTR_WIDTH-1];
generate
    genvar j;
    for(j=0; j<PTR_WIDTH-1; j=j+1) begin
        assign g_nxt[j] = bin_nxt[j+1] ^ bin_nxt[j];
    end        
endgenerate

always_ff @(posedge clk ,negedge rst_n) begin
    if(~rst_n)
        ptr <= {PTR_WIDTH{1'b0}};
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
