module key_register #(parameter key_width = 32, parameter index_width = 8, parameter PE = 4)(
    input clk, 
    input reset, 
    input [index_width*2-1:0] w_addr,
    input [index_width*2-1:0] r_addr, 
    input [key_width*2-1:0] key_in_write, 
    input [1:0]w_en,
    input [1:0]r_en, 
    output [key_width*2-1:0]key_out_read
);
reg [key_width-1:0] Reg_array[(2**index_width)-1:0];
//reg [key_width-1:0] write_buffer;
//reg w_en_buffer;
integer i; 
always @(posedge clk, negedge reset) begin
    
    for (i = 0; i<2 ; i=i+1) begin
        if (w_en[i]) begin
            Reg_array[w_addr[i*index_width+:index_width]] <= key_in_write[i*index_width+:index_width];
        end
    end
            
    for (i=0; i<2; i=i+1 )
        if (r_en[i]) begin
            key_out_read[i*index_width+:index_width] <= Reg_array[r_addr[i*index_width+:index_width]];
        end
end    
endmodule