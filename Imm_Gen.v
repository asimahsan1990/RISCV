module Imm_Gen#(parameter WIDTH=32)(
    input[31:0] instr,
    input [1:0] ImmSel,
    output reg [WIDTH-1:0]Imm

);



always @(*) begin
    case(ImmSel)
        0:Imm=$signed(instr[31:20]);
        1:Imm=$unsigned(instr[31:20]);
        2:Imm=$unsigned(instr[24:20]);
        3:Imm=$unsigned({instr[31:25],instr[11:7]});
    endcase
end




endmodule