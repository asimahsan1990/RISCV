module  alu#(parameter WIDTH=32)(
	input wire[3:0]	ALUSel ,
	input wire [WIDTH-1:0] in_a   ,
	input wire [WIDTH-1:0] in_b   ,
	output a_is_zero,
	output reg [WIDTH-1:0] alu_out);

assign a_is_zero=in_a? 0:1;

always@(*)
begin
	case(ALUSel)
	0:
		begin//add
			alu_out=in_a+in_b;
		end
	1:
		begin//sub
			alu_out=in_a-in_b;
			
		end
	2:
		begin//sll
			alu_out=in_a<<in_b;

		end

	3:
		begin//slt
			alu_out=$signed(in_a)<$signed(in_b)?1:0;

		end
	4:
		begin//sltu
			alu_out=$unsigned(in_a)<$unsigned(in_b)?1:0;

		end
	5:
		begin//xor
			alu_out=in_a^in_b;

		end
	6:
		begin//srl
			alu_out=in_a>>in_b;
		end
	7:
		begin
			alu_out=in_a>>>in_b;

		end
	8:
		begin
			alu_out=in_a|in_b;

		end
	9:
		begin
			alu_out=in_a&in_b;

		end
	default:
			$display("ALU case not defined");
	endcase
end
	
endmodule


