module Top_module(input clk,
                  input rst);

    localparam width =32 ;



    wire[width-1:0] pc_in;
    wire[width-1:0] pc_4;
    wire[width-1:0] pc_out;


    assign pc_4 =pc_out+4;//pc +4


wire[width-1:0] ALU_Output;


wire[3:0] ALUSel;
wire PCSel;
wire RegWEn;


    multiplexor
  #(
    .WIDTH   ( width  ) 
   )
    alu_add4_mux
   (
    .sel     ( PCSel   ),
    .in0     ( pc_4 ),
    .in1     ( ALU_Output ),
    .mux_out ( pc_in   ) 
   ) ;


    

    
    register
    #(
        .WIDTH    ( width ) 
    )
        program_counter_register
    (
        .clk      ( clk    ),
        .rst      ( rst    ),
        .load     ( 1'b1  ),
        .data_in  ( pc_in  ),
        .data_out (   pc_out )
    ) ;
  wire [31:0] instr;


  memory_byte#(.AWIDTH(10),.DWIDTH(8), .DPORT(32) )
        instruction_memory(
        .clk(clk)     ,
        .wr(1'b0)      ,
  			.byte(1'b0)       ,
        .addr(pc_out)  ,
        .data_in(32'b0),
        .data_out(instr)		
);

wire[width-1:0] Oprand_A;
wire[width-1:0] Oprand_B;

register_file#(.DWIDTH(width))
  regfile(
  .clk(clk)   ,
  .wr(RegWEn)    ,
  .Addr_A(instr[19:15]) ,
  .Addr_B (instr[24:20]),
  .Addr_D (instr[11:7]),
  .Data_D(ALU_Output),
  .Data_A(Oprand_A),
  .Data_B(Oprand_B)
	
);



 alu#(.WIDTH(width))
 alu_instance(
.ALUSel(ALUSel) ,
.in_a(Oprand_A)   ,
.in_b(Oprand_B)   ,
.alu_out(ALU_Output)
);



controller controller_inst(
.instr(instr),
.PCSel(PCSel),
.RegWEn(RegWEn),
.ALUSel(ALUSel)
        );
    
  
endmodule