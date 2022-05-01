module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    parameter IDLE=0,BYTE0=1,BYTE1=2,BYTE2=3;
    reg [1:0] state,next;
    reg [7:0] in1;
    wire [23:0] out_bytes1;
    
    always@(posedge clk)
        begin
            if(reset) state<=IDLE;
            else state<=next;
        end
    
    always@(*)
        begin
            case(state)
                IDLE: next = in[3]?BYTE0:IDLE;
                BYTE0:next = BYTE1;
                BYTE1:next = BYTE2;
                BYTE2:next = in[3]?BYTE0:IDLE;
            endcase
        end
   
    //说明：
    //在检测到输入有效（in[3]==1）的下一个周期，才进入BYTE0状态，而此时的输入in已经是第二个有效字节（BYTE2）
    //所以需要用寄存器暂存上一时钟周期的in值
    //上一时钟周期的in值与现在的byte状态相对应
    always@(posedge clk) in1<=in;
    
    always@(*)
        begin
            case(state)
                IDLE: out_bytes1 = 24'b0;
                BYTE0:out_bytes1[23:16]=in1;
                BYTE1:out_bytes1[15:8] =in1;
                BYTE2:out_bytes1[7:0]  =in1;
            endcase
        end

    assign done = (state==BYTE2);    
	assign out_bytes = done?out_bytes1:0;            
  

endmodule
