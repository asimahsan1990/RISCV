module Top_module(input clk,
                  input rst);

    localparam width =32 ;


    //PC wire
    wire[width-1:0] pc_in;
    wire[width-1:0] pc_4;
    wire[width-1:0] pc_out;

    // PC adder
    assign pc_4 =pc_out+4;//pc +4

    //ALU wire
    wire[width-1:0] ALU_Output;

    //imm gen
    wire [width-1:0] Imm;

    //controller wires
    wire[3:0] ALUSel;
    wire PCSel;
    wire RegWEn;
    wire BSel;
    wire[1:0] ImmSel;
  
  //data memory
    wire [width-1:0] data_memory_out;

    multiplexor
  #(
    .WIDTH   ( width  ) 
   )
    pc_add4_mux
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
wire[width-1:0] WB;

    register_file#(.DWIDTH(width))
      regfile(
      .clk(clk)   ,
      .wr(RegWEn)    ,
      .Addr_A(instr[19:15]) ,
      .Addr_B (instr[24:20]),
      .Addr_D (instr[11:7]),
      .Data_D(WB),
      .Data_A(Oprand_A),
      .Data_B(Oprand_B)
      
    );

    Imm_Gen #(.WIDTH(width))Imm_instance(
        .instr(instr),
        .ImmSel(ImmSel),
        .Imm(Imm)

    );

wire[width-1:0] Source_B;

    multiplexor
  #(
    .WIDTH   ( width  ) 
   )
    source_B_sel_mux
   (
    .sel     ( BSel   ),
    .in0     ( Oprand_B ),
    .in1     ( Imm ),
    .mux_out ( Source_B   ) 
   ) ;



    alu#(.WIDTH(width))
    alu_instance(
    .ALUSel(ALUSel) ,
    .in_a(Oprand_A)   ,
    .in_b(Source_B)   ,
    .alu_out(ALU_Output)
    );

    memory_byte#(.AWIDTH(10),.DWIDTH(8), .DPORT(32) )
        data_memory(
        .clk(clk)     ,
        .wr(1'b0)      ,
  			.byte(1'b0)       ,
        .addr(ALU_Output)  ,
        .data_in(32'b0),
        .data_out(data_memory_out)		
      );

      wire[2:0] load_op;
      wire [width:0] data_parsing_out;

memory_load#(.WIDTH(width)) load_memory (
    .data_in(data_memory_out),
    .load_op(load_op),
    .data_out(data_parsing_out)
     
    );


   

    multiplexor
  #(
    .WIDTH   ( width  ) 
   )
    reg_source_sel_mux
   (
    .sel     ( WBSel  ),
    .in0     ( data_parsing_out ),
    .in1     ( ALU_Output ),
    .mux_out ( WB   ) 
   ) ;

   



    controller controller_inst(
    .instr(instr),

    .PCSel(PCSel),
    .RegWEn(RegWEn),
    .ImmSel(ImmSel),
    .BSel(BSel),
    .WBSel(WBSel),
    .ALUSel(ALUSel),
    .load_op(load_op)

    );
    
  
endmodule