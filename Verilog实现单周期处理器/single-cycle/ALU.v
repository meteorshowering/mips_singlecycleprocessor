`timescale 1ns / 1ps
module ALU(
    input [31:0]in1,
    input [31:0]in2,
    input Sign,
    input [4:0]ALUCtrl,
    output reg [31:0]out,
    output wire zero
);
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
    
    assign zero = (out == 31'd0)? 1:0;
    always @(*) begin
    case(ALUCtrl)
        lui: out <= {in2[15:0],16'd0}; //ÏòÉÏÒÆ16
        add: out <= in1 + in2;
        sub: out <= in1 - in2;
        And: out <= in1 & in2;
        Or: out <= in1 | in2;
        Xor: out <= in1 ^ in2;
        Nor: out <= ~(in1 | in2);
        sll: out <= (in1 << (in2[4:0]));
        srl: out <= (in1 >> (in2[4:0]));
        sra: out <= ({{32{in1[31]}},in1} >> (in2[4:0]));
        slt: begin 
            if(Sign) 
            begin 
                if((!in1[31]) & in2[31]) 
                    out <= 32'd1; 
                else if( in1[31] & (!in2[31])) 
                    out <= 32'd0;
                else    out <= {31'd0, (in1[30:0] > in2[30:0])};
            end
            else begin 
                out <= {31'd0, (in1>in2)};
            end
            end
        jr: out <= in1; 
        default: out <= 32'd0;
    endcase
    end
endmodule