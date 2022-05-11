module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    
  
//   状态说明
//   start表示0状态
//   rece（n）表示接收到n个1
//   DISC\FLAG\ERROR状态与输出相对应
  
//   仔细思考需不需要IDLE状态
//   如果需要，IDLE在in=0后转为start状态，in=1保持
//   START在in=1时回到IDLE,in=0保持
//   在检测011……序列时，如果有IDLE状态 那么状态转移IDLE->START->RECE1
//                     没有IDLE状态              START->START->RECE1
//   也就是说，IDLE只是一个冗余状态 
  
  
//  pamameter IDLE=0;
    parameter START=1,RECE1=2,RECE2=3,RECE3=4,RECE4=5,RECE5=6,RECE6=7,DISC=8,FLAG=9,ERROR=10;
    reg [3:0] state,next;
    
    always@(posedge clk)
        begin
            if(reset) state<=START;
            else      state<=next;
        end
    
    always@(*)
        begin
            case(state)
                //IDLE:  next = in?IDLE :START;
                START: next = in?RECE1:START;
                RECE1: next = in?RECE2:START;
                RECE2: next = in?RECE3:START;
                RECE3: next = in?RECE4:START;
                RECE4: next = in?RECE5:START;
                RECE5: next = in?RECE6:DISC;
                DISC:  next = in?RECE1:START;
                RECE6: next = in?ERROR:FLAG;
                ERROR: next = in?ERROR:START;
                FLAG:  next = in?RECE1:START;
                default: next = START;
            endcase
        end
    
    assign disc = (state==DISC);
    assign flag = (state==FLAG);
    assign err  = (state==ERROR);

endmodule
