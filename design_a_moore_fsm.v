module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 

  //状态说明：
  //A-水位below S1
  //B-水位between S1-S2
  //C-水位between S2-S3
  //D-水位above S3
  //1-上一状态水位比现状态水位高，output dfr=1
  //0-上一状态水位比现状态水位低，output dfr=2
  //没有比below S1更低的水位，所以上一个状态一定比它水位高，对应只有A1状态
  //没有比above S2更高的水位，所以上一个状态一定比它水位低，对应只有D0状态
  
    parameter A1=0,B0=1,B1=2,C0=3,C1=4,D0=5;
    reg [2:0] state;
    reg [2:0] next_state;
    
    always@(posedge clk)
        begin
            if (reset)
               state <= A1;
            else
               state <= next_state;
        end
  
  
  //状态转移
  //水位上升到0状态
  //水位下降到1状态
    always@(*)
        begin
            case(state)
                A1: next_state = s[1]?B0:A1;
                B0: next_state = s[2]?C0:(s[1]?B0:A1);
                B1: next_state = s[2]?C0:(s[1]?B1:A1);
                C0: next_state = s[3]?D0:(s[2]?C0:B1);
                C1: next_state = s[3]?D0:(s[2]?C1:B1);
                D0: next_state = s[3]?D0:C1;
                default: next_state = state;
            endcase
        end

  //状态对应的输出
  //水位越低，要开启的fr越多
	always@(*)
        begin
            case(state)
                A1: {fr3,fr2,fr1,dfr} = 4'b1111;
                B0: {fr3,fr2,fr1,dfr} = 4'b0110;
                B1: {fr3,fr2,fr1,dfr} = 4'b0111;
                C0: {fr3,fr2,fr1,dfr} = 4'b0010;
                C1: {fr3,fr2,fr1,dfr} = 4'b0011;
                D0: {fr3,fr2,fr1,dfr} = 4'b0000;
                default:{fr3,fr2,fr1,dfr} = 4'b0000;
            endcase
        end

endmodule
