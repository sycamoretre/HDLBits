module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);
   
    //说明：
    //从端口说明中可以看出，这是一个组合逻辑电路，且state为输入
    //如果使用传统的三段式来写，不仅要单独设计状态转移图中没有的idle状态，还要设计当输入state中不止一位有效时的状态转移优先级
    //但使用这种方式来完成有限状态机，仅限此案例
  
   /* parameter s0=10'b0000000001,s1=10'b0000000010,s2=10'b0000000100,s3=10'b0000001000,s4=10'b0000010000;
    parameter s5=10'b0000100000,s6=10'b0001000000,s7=10'b0010000000,s8=10'b0100000000,s9=10'b1000000000;
    parameter IDLE=10'b0000000000;
    
    always@(*)
        begin
            case(state)
                IDLE:next_state=IDLE;
                s0:next_state=in?s1:s0;
                s1:next_state=in?s2:s0;
                s2:next_state=in?s3:s0;
                s3:next_state=in?s4:s0;
                s4:next_state=in?s5:s0;
                s5:next_state=in?s6:s8;
                s6:next_state=in?s7:s9;
                s7:next_state=in?s7:s0;
                s8:next_state=in?s1:s0;
                s9:next_state=in?s1:s0;
                default: next_state=s0;
            endcase
        end
    assign out1=(state==s8)|(state==s9);
    assign out2=(state==s7)|(state==s9);
*/
    //state transition logic
    assign next_state[0] = (!in)&(state[0]|state[1]|state[2]|state[3]|state[4]|state[7]|state[8]|state[9]);
    assign next_state[1] = in&(state[0]|state[8]|state[9]);
    assign next_state[2] = in&state[1];
    assign next_state[3] = in&state[2];
    assign next_state[4] = in&state[3];
    assign next_state[5] = in&state[4];
    assign next_state[6] = in&state[5];
    assign next_state[7] = in&(state[6]|state[7]);
    assign next_state[8] = (!in)&state[5];
    assign next_state[9] = (!in)&state[6];
    
    //output logic
    assign out1 = state[8]|state[9];
    assign out2 = state[7]|state[9];
         
endmodule
