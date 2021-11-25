module controller(
        input[31:0] instr,
        output reg PCSel,
        output reg RegWEn,
        output reg BSel,
        output reg [1:0]ImmSel,
        output reg [3:0] ALUSel
        );

wire[6:0] opcode;
wire[2:0] fuct3;
wire[6:0] fuct7;

//assign PCSel=0;
//assign RegWEn=1;

assign opcode=instr[6:0];
assign fuct3=instr[14:12];
assign fuct7=instr[31:25];

always @(*) begin
    case(opcode)
        'h13: //itype arithmatic
            begin
                BSel=1;
                RegWEn=1;
                PCSel=0;
                ImmSel=0;
                case(fuct3)
                0:ALUSel=0;
                1:ALUSel=2;
                2:ALUSel=3;
                3:begin ALUSel=4; ImmSel=1;end
                4:ALUSel=5;
                5:ALUSel=fuct7[5]?7:6;
                6:ALUSel=8;
                7:ALUSel=9;
                endcase
                                
                
            end

        'h33://rtype aritmatic
            begin
                BSel=0;
                RegWEn=1;
                PCSel=0;
                case(fuct3)
                0:ALUSel=fuct7[5]?1:0;
                1:ALUSel=2;
                2:ALUSel=3;
                3:ALUSel=4;
                4:ALUSel=5;
                5:ALUSel=fuct7[5]?7:6;
                6:ALUSel=8;
                7:ALUSel=9;
                endcase
            end

            default: $display("Unkonwn Instruction");
        
    endcase
    
end

endmodule