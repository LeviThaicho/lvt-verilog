module LVT_register_based #(
    parameter p = 4,
    parameter n_PE_bits = 2,
    parameter index_width = 8
) (
    input clk,
    input reset,
    input [p*index_width-1:0] addr,
    input [p-1:0] w_en;
   // input [p*index_width-1:0] read_addr,
    input [p-1:0] r_en;
    output reg [p*n_PE_bits-1:0]lvt_sel;
);
reg [n_PE_bits-1:0]lvt_reg_storage[2**index_width-1:0];
integer i;
always @(posedge clk, negedge reset) begin
    if(~reset) begin
        for (i =0 ;i<2**index_width ; i=i+1) begin
            lvt_reg_storage[i] = {n_PE_bits{1'b0}};
        end
    end
    else begin
        
        for (i = 0; i < p ; i = i+1) begin
            if (w_en[i]) begin
                lvt_reg_storage[addr[i*index_width+:index_width]] <= i;
            end
        end

        for (i = 0; i < p ; i = i+1) begin
            if (r_en[i]) begin
                lvt_sel[i*p+:p] <= lvt_reg_storage[addr[i*index_width+:index_width]]; 
            end
        end

    end
end
endmodule