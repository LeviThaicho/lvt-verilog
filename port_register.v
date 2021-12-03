module port_register #(parameter index_width = 8, parameter  data_width = 64, parameter processing_engines = 4) (
    input clk,
    input reset,
    input [data_width-1:0] write_in_kandv,
    input [data_width-1:0] read_in_kandv,
    input [index_width-1:0]addr,
    input wen,
    input ren,
    output reg [data_width-1:0] read_out_kandv,
    output reg[data_width-1:0] write_out_kandv,
    output reg wen_out,
    output reg ren_out,
    output reg [index_width-1:0]addr_out
);

// reg [data_width-1:0] read_reg, write_reg;
// reg wen_reg,ren_reg;
// reg [index_width-1:0] addr_reg;

// assign write_out_kandv[data_width-1:0] = write_reg[data_width-1:0];
// assign read_out_kandv[data_width-1:0] = read_reg[data_width-1:0]; 
// assign wen_out = wen_reg;
// assign ren_out = ren_reg;
// assign addr_out[index_width-1:0] = addr_reg[index_width-1:0]

always @(posedge clk, negedge reset) begin
    if (~reset) begin
        read_out_kandv <= 0;
        write_out_kandv <= 0;
        wen_out <= 0;
        ren_out <= 0;
        addr_out <= 0;
    end
    else begin
        read_out_kandv <= read_in_kandv;
        write_out_kandv <= write_in_kandv;
        wen_out <= wen;
        ren_out <= ren;
        addr_out <= addr;

    end    
end
endmodule