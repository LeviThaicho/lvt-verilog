module valid_and_r_count_array #(
    parameter index_width = 8,
    parameter r = 4, 
    parameter n_bits_r = 2
) (
    input clk, 
    input reset, 
    input [index_width-1:0]addr,
    input w_en;
    output [n_bits_r-1:0] bram_index
);
reg [n_bits_r-1:0] valid_array [2**index_width-1:0]    
always @(posedge clk, negedge reset) begin
    if (~reset) begin
        for (i = 0; i<2**index_width-1; i=i+1) begin
            valid_array[i] <= {n_bits_r{1'b0}};
        end
    end
    else begin
        if (w_en) begin
            bram_index <= valid_array[addr];
            valid_array[addr] <= valid_array[addr] + 1;
        end
    end
end
endmodule