module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

  
  //相对于serial.v的变化
  //在done为真时输出接收到的8bit数据
    
  // Use FSM from Fsm_serial
    parameter IDLE=0,START=1,DONE=2, ERROR=3;
    reg [1:0] state,next;
    reg [7:0] out_byte1;
  //out_byte1用于暂存输入in的数据
    int cnt;
    
    always@(posedge clk)
        begin
            if(reset) state<=IDLE;
            else state<=next;
        end
    
    always@(posedge clk)
        begin
            if(reset) cnt<=0;
            else if(state==START && cnt<8) cnt<=cnt+1;
            else cnt<=0;
        end
    
  //在start状态接受，done状态赋值
    always@(posedge clk)
        begin
            if(state==START)
                out_byte1[cnt]<=in;
            else 
                out_byte1<=0;
        end
    
    always@(*)
        begin
            case(state) 
                IDLE: next = (~in)?START:IDLE;
                START:begin
                    if(cnt==8) next=in?DONE:ERROR;
                    else next=START;
                end
                DONE: next = (~in)?START:IDLE;
                ERROR:next = in?IDLE:ERROR;
            endcase
        end
    
    assign done = (state==DONE);
    assign out_byte = (state==DONE)?out_byte1:0;

    // New: Datapath to latch input bits.

endmodule
