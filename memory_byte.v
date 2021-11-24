module memory_byte#(parameter AWIDTH=32,DPORT=32,DWIDTH=8)(
  input               clk   ,
  input               wr    ,
  input				  byte,
  input  [AWIDTH-1:0] addr  ,
  input [DPORT-1:0] data_in,
  output [DPORT-1:0] data_out

		
);

reg [DWIDTH-1:0] array[0:((1<<AWIDTH) -1)];//
assign data_out = byte?{24'b0,array[addr]}:{array[addr+3],array[addr+2],array[addr+1],array[addr]};


always@(posedge clk)
begin
	 if(wr)
		begin
			if(byte)
				begin
					array[addr]=data_in[7:0];
				end
			else
				begin
					{array[addr+3],array[addr+2],array[addr+1],array[addr]}=data_in;
				end
			
		end

end



endmodule
