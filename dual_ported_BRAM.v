module dual_ported_bram #(parameter value_width = 32, parameter index_width = 8, parameter processing_engines = 4)
(clka, clkb, ena, enb, wea, web, addra, addrb, dia, dib, doa, dob);
input clka, clkb, ena, enb, wea, web;
input [index_width-1:0] addra, addrb;
input [value_width-1:0] dia, dib;
output [value_width-1:0] doa, dob;
reg [value_width-1:0] bram [2**index_width - 1:0];
reg  [value_width-1:0] doa, dob;

always @(posedge clka) begin
    if (ena) begin
        if (wea) begin
            bram[addra] <= dia;
        doa <= bram[addra];
        end
    end
end

always @(posedge clk) begin
    if (enb) begin
        if (web) begin
            bram[addrb] <= dib;
        dob <= bram[addrb];
        end
    end
end

endmodule