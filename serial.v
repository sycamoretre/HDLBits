module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    parameter IDLE=0,START=1,DONE=2, ERROR=3;
    reg [1:0] state,next;
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
   
    //idle状态时cnt=0
    //in=0 检测到开始标志时 cnt仍然=0
    //真正开始传输串行数据，到有效数据的第一个bit，cnt才=1
    //也就是说，cnt需要从1计数到8才完成数据传输
    //虽然cnt从零开始计数，但至少要计数到8才行
    //所以 if（cnt==8）
    always@(*)
        begin
            case(state) 
                IDLE: next = (~in)?START:IDLE;
                START:begin
                    //if(cnt<8) next=START;
                    //else next=in?DONE:ERROR;
                    if(cnt==8) next=in?DONE:ERROR;
                    else next=START;
                end
                DONE: next = (~in)?START:IDLE;
                ERROR:next = in?IDLE:ERROR;
            endcase
        end
    
    assign done = (state==DONE);

endmodule
