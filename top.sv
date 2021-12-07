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
    LVT_register_based#(p,n_PE_bits,index_width)(
        .clk(clk),
        .reset(reset),
        .addr(addr[p*index_width-1:0]),
        .w_en(wen),
        .r_en(ren),
        .lvt_sel(lvt_select)
    );


//-----------------bram instantiation-------------/
wire [value_width-1:0] value_wire [p*(p-1)-1:0][r-1:0];

generate
integer ct=0;
    for(i=0;i<p;i=i+1)row
        for(j=i+1;j<p;j=j+1)column
            for(k=0;k<r;k=k+1)replication begin
                  
            end   

endgenerate




//------------------

endmodule