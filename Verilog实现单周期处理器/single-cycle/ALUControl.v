
module ALUControl(OpCode, Funct, ALUCtrl, Sign);
	input [5:0] OpCode;
	input [5:0] Funct;
	output reg [4:0] ALUCtrl;
	output reg Sign;
	
	// Your code below

	parameter null=5'b0;
    parameter add=5'b00001;
    parameter sub=5'b00010;
    parameter And=5'b00011;
    parameter Or=5'b00100;
    parameter Xor=5'b00101;
    parameter Nor=5'b00110;
    parameter sll=5'b00111;
    parameter srl=5'b01000;
    parameter sra=5'b01001;
    parameter slt=5'b01010;
    parameter jr=5'b01011;
    parameter lui=5'b01100;
	always @(*)
	begin
	   if (OpCode!=6'h0)
	       begin
	           case(OpCode)
	               6'h23:ALUCtrl=add;//lw
	               6'h2b:ALUCtrl=add;//sw
	               6'hf:ALUCtrl=lui;//lui
	               6'h8:ALUCtrl=add;//addi
	               6'h9:ALUCtrl=add;//addiu
	               6'hc:ALUCtrl=And;//andi
	               6'ha:ALUCtrl=slt;//slt
	               6'hb:ALUCtrl=slt;//sltiu
	               6'h4:ALUCtrl=sub;//beq
	               default:ALUCtrl=null;
	               endcase
               end
       else
       begin
        case(Funct)
        6'h20:ALUCtrl=add;//add
        6'h21:ALUCtrl=add;//addu
        6'h22:ALUCtrl=sub;//sub
        6'h23:ALUCtrl=sub;//subu
        6'h24:ALUCtrl=And;//and
        6'h25:ALUCtrl=Or;//or
        6'h26:ALUCtrl=Xor;//xor
        6'h27:ALUCtrl=Nor;//nor
        6'h0:ALUCtrl=sll;//sll
	    6'h2:ALUCtrl=srl;//srl
	    6'h3:ALUCtrl=sra;//sra
	    6'h2a:ALUCtrl=slt;//slt
	    6'h2b:ALUCtrl=slt;//slt
	    6'h8:ALUCtrl=jr;
	    6'h9:ALUCtrl=jr;
	    default:ALUCtrl=add;
	    endcase
	    end        
        if(Funct == 6'b100001 || Funct == 6'b100011 || OpCode == 6'd9 || Funct == 6'b101011 || OpCode == 6'b001011)
        Sign <= 0;
        else Sign <= 1;
    end
	     
	// Your code above

endmodule
