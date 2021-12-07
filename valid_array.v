module valid_and_r_count_array #(
    parameter index_width = 8,
    parameter r = 4, 
    parameter n_bits_r = 4
) (
    input clk, 
    input reset, 
    input [2*index_width-1:0]addr1,
    input [1:0]w_en,
    output [n_bits_r-1:0] bram_index
);
reg [n_bits_r-1:0] valid_array [2**index_width-1:0];
integer i; 
always @(posedge clk, negedge reset) begin
    if (~reset) begin
        for (i = 0; i<2**index_width-1; i=i+1) begin
            valid_array[i] <= {n_bits_r-1{1'b0},{1'b1}};
        end
    end
    else begin
        for (i =0 ;i<2 ;i++ ) begin
          if (w_en[i]) begin
            bram_index <= valid_array[addr1[i*index_width+:index_width]];
            valid_array[addr] <= valid_array[addr] + 1;
         end
        end
    end
end
endmodule