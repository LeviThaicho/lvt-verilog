module lvt_hash #(parameter  = )(
    input [p*data_width-1:0] write_data,
    input [p-1:0] wen,
    input [p-1:0] ren,
    input [p*data_width-1:0] read_data,
    input [p*index_width-1:0]addr,
    output
);

//----------wire for ports-----------------//
wire [data_width-1:0] write_data [p-1:0];
wire [data_width-1:0] read_data [p-1:0];
wire [index_width-1:0] addr_wire [p-1:0];
wire ren_wire[p-1:0];
wire wen_wire[p-1:0];
genvar i;
genvar j;
genvar k;
//------------read write port instantiation---------//
generate
    for(i=0; i<p; i=i+1) begin
       port_register #(index_width, data_width, p)port_reg_inst(
            .clk(clk),
            .reset(reset),
            .write_in_kandv(write_data[i*data_width+:data_width]),
            .read_in_kandv(read_data[i]),
            .addr(addr),
            .wen(wen),
            .ren(ren),
            .read_out_kandv(read_data[i*data_width+:data_width]),
            .write_out_kandv(write_data[i]),
            .wen_out(wen_wire[i]),
            .ren_out(ren_wire[i]),
            .addr_out(addr_wire[i])
       ); 
    end
endgenerate

wire [p-1:0:] lvt_select ;
//------------------lvt instantiation-----------------//
    LVT_register_based#(p,n_PE_bits,index_width)lvt_inst(
        .clk(clk),
        .reset(reset),
        .addr(addr[p*index_width-1:0]),
        .w_en(wen),
        .r_en(ren),
        .lvt_sel(lvt_select)
    );

//-----------------value registers----------------//
integer ct=0;
//wire [p * (p-1)-1:0][index_width-1:0] valid_reg_addr_wire;
wire [p * ((p-1)/2)-1:0][n_r_bits-1:0] valid_reg_out_wire;

for (i = 0; i<p; i=i+1) begin
    for (j=i+1; j<p; j=j+1)begin
        valid_and_r_count_array #(
            parameter index_width = 8,
            parameter r = 4, 
            parameter n_bits_r = 4
        ) valid_inst(
            .clk(clk), 
            .reset(reset), 
            .addr1({addr_wire[i][index_width-1]},{addr_wire[j][index_width-1]}),
            .w_en({wen_wire[i]},{wen_wire[j]}),
            .bram_index(valid_reg_out_wire[ct])
    ); 
    ct = ct+1;       
    end
end
//-----------------bram instantiation-------------//

wire [p*(p-1)-1:0][value_width-1:0] value_wire;

generate
integer ct=0;
    for(i=0;i<p;i=i+1)begin
        for(j=i+1;j<p;j=j+1)begin          
            for(k=0;k<r;k=k+1) begin
                  blk_mem_gen_0 #(/*add parameters*/) uram_inst(
                                    .clka(clk),
                                    .ena(valid_reg_out_wire[ct][k]),
                                    .wea(wen_wire[i]),
                                    .addra(addr_wire[i]),
                                    .dina(),   // write data from port wire
                                    .douta(),  //connect data to wire, using select from lvt direct proper data to rread port
                                    .clkb(clk),
                                    .enb(valid_reg_out_wire[ct+1][k]),
                                    .web(wen_wire[j]),
                                    .addrb(addr_wire[j]),
                                    .dinb(),     //
                                    .doutb());     //           
            end   
        end
    end
endgenerate




//------------------

endmodule