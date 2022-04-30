module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

    
    //状态说明：
    //IDLE用于检测in[3]
    //COUNT计数已经采集到的字节数
    //DONE为完成计数的符号
    //在DONE状态，即此次信号传输完成时，同时检测in[3]，而不是回到idle状态再检测
    //这样才能连续采样
    parameter IDLE=0, COUNT=1, DONE=2;
    reg [1:0] state, next_state;
    reg [4:0] cnt;
    
    
    //不要把flag信号和cnt信号写在同一个always块中，否则flag信号会比cnt计数到特定值的信号慢一拍
    always@(posedge clk)
        begin
            if(reset) begin
                    cnt<=0;
                end
            else if(state==COUNT)begin
                if(cnt==1) cnt<=0;
                else cnt<=cnt+1;
            end
        end
    
    // State transition logic (combinational)
    always@(*)
        begin
            case(state)
                IDLE: next_state = in[3]?COUNT:IDLE;
                COUNT:next_state = (cnt==1)?DONE:COUNT;
                DONE: next_state = in[3]?COUNT:IDLE;
                default:next_state = IDLE;
            endcase
        end
    // State flip-flops (sequential)
    always@(posedge clk)
        begin
            if(reset)
                state <= IDLE;
            else
                state <= next_state;
        end
    // Output logic
    assign done = (state == DONE);

endmodule
