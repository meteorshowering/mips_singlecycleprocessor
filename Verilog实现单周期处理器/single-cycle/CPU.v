
module CPU(reset, clk);
	input reset, clk;
    //--------------Your code below-----------------------
    reg [31:0]PCAdd; 
    wire [31:0]pc_add;
    wire [31:0]nextPC;
    wire [31:0]Instruction;
       always @(posedge clk or posedge reset) begin
         if(reset) begin
             PCAdd <= 32'd0;

         end
         else begin
             PCAdd <= nextPC;
         end
     end


    //取指令
    InstructionMemory IM(PCAdd, Instruction); // Insruction Memory
    
    wire [1:0]PCSrc; 
    wire Branch; 
    wire RegWrite; 
    wire [1:0]RegDst;
    wire MemRead; 
    wire MemWrite; 
    wire [1:0]MemtoReg;
    wire ALUSrc1; 
    wire ALUSrc2; 
    wire ExtOp; 
    wire LuOp;
//指令译码;
    Control genectrl(
        .OpCode(Instruction[31:26]), 
        .Funct(Instruction[5:0]),
        .PCSrc(PCSrc), 
        .Branch(Branch), 
        .RegWrite(RegWrite), 
        .RegDst(RegDst), 
        .MemRead(MemRead),    
        .MemWrite(MemWrite), 
        .MemtoReg(MemtoReg),
        .ALUSrc1(ALUSrc1), 
        .ALUSrc2(ALUSrc2), 
        .ExtOp(ExtOp), 
        .LuOp(LuOp)
    );

    
    wire [4:0]writereg; 
    wire[31:0]writedata;
    wire [31:0]read1; 
    wire [31:0]read2;
    assign writereg = (RegDst == 2'b01)? Instruction[20:16]: (RegDst == 2'b00)? Instruction[15:11]: 5'b11111;
    assign writedata=(MemtoReg==2'd2)?PCAdd:(MemtoReg==2'd1)?memdata:ALUOut;

    //寄存器的使用
   RegisterFile register(
        .reset(reset), 
        .clk(clk), 
        .RegWrite(RegWrite), 
        .Read_register1(Instruction[25:21]), 
        .Read_register2(Instruction[20:16]), 
        .Write_register(writereg),
        .Write_data(writedata), 
        .Read_data1(read1), 
        .Read_data2(read2));

    
    wire [31:0]in2; 
    wire [31:0]in1;
    wire [4:0]ALUCtrl; 
    wire Sign; 
    wire [31:0]ALUOut; 
    wire zero;
    
    assign in1=ALUSrc2?read2:read1;
    assign in2=(ALUSrc2&&ExtOp)?{{27{Instruction[10]}}, Instruction[10:6]}:
        (ALUSrc2&&~ExtOp)?{27'd0, Instruction[10:6]}:
        (~ALUSrc2&&ALUSrc1&&ExtOp)?{{16{Instruction[15]}}, Instruction[15:0] }:
        (~ALUSrc2&&ALUSrc1&&~ExtOp)? {16'd0, Instruction[15:0]}:read2;
    //生成ALU控制信号
    ALUControl aluctrl(
        .OpCode(Instruction[31:26]), 
        .Funct(Instruction[5:0]), 
        .ALUCtrl( ALUCtrl), 
        .Sign(Sign)
        );
        //ALU
    ALU alu(
        .in1(in1), 
        .in2(in2), 
        .Sign(Sign), 
        .ALUCtrl(ALUCtrl), 
        .out(ALUOut), 
        .zero(zero)
        ); 
    //datamemory
    wire [31:0]memdata;
    DataMemory datamem(
        .reset(reset), 
        .clk(clk), 
        .Address(ALUOut), 
        .Write_data(read2), 
        .Read_data(memdata), 
        .MemRead(MemRead), 
        .MemWrite(MemWrite)
        );
   assign pc_add = PCAdd + 32'd4;
   assign nextPC =((PCSrc == 2'd0)&&Branch && zero)?pc_add + {14'd0, Instruction[15:0], 2'b00}:
                (PCSrc == 2'd1)?{pc_add[31:28], Instruction[25:0] , 2'b00}:
                (PCSrc == 2'd2)? memdata:pc_add;
    
    //--------------Your code above-----------------------
endmodule
	