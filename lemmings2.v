module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
    
  
  //状态说明：
  //LF-向左走
  //RT-向右走
  //LFD-摔倒时向左
  //RTD-摔倒时向右
  
    parameter LF=0,RT=1,LFD=2,RTD=3;
    reg [1:0] state, next_state;
    reg ground1;
    
    always@(posedge clk or posedge areset)
        begin
            if(areset)
                state <= LF;
            else
                state <= next_state;
        end
   
  //ground信号在状态转移时为边缘触发，ground1存储ground的上一个状态
  
    always@(posedge clk) ground1<=ground;
    
    
    always@(*)
        begin
            case(state)
                //LF: next_state=bump_left?RT:((ground1^ground)?LFD:LF); 错误
                //RT: next_state=bump_right?LF:((ground1^ground)?RTD:RT); 错误
                //按照报错的时序图来看，再向左走的状态下，同时出现左边障碍和坑时，输出aaah
                //所以应当先判断是否摔倒，再判断是否有障碍
              
                LF: next_state=(ground1^ground)?LFD:(bump_left?RT:LF);
                RT: next_state=(ground1^ground)?RTD:(bump_right?LF:RT);
                LFD: next_state=(ground1^ground)?LF:LFD;
                RTD: next_state=(ground1^ground)?RT:RTD;
            endcase
        end
    
    assign walk_left=(state==LF);
    assign walk_right=(state==RT);
    assign aaah=(state==LFD)|(state==RTD);

endmodule
