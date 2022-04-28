module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    
  
  //状态说明
  //LF = go left
  //RT = go right
  //LFD= down left
  //RTD= down right
  //LFG= dig left
  //RTG= dig right
  
    parameter LF=0,RT=1,LFD=2,RTD=3,LFG=4,RTG=5;
    reg [2:0] state, next_state;
    
    always @(posedge clk or posedge areset)
        begin
            if(areset)
                state <= LF;
            else
                state <= next_state;
        end
    
  
  //ground=1表示路，ground=0表示坑，在路上走在坑里挖
  //障碍在路上，在坑里挖的时候不考虑bump，也就是说对dig信号的判定优先于bump
  //继承于lemmings2，对ground的判定为最高级
    always @(*)
        begin
            case(state)
                LF: begin
                    if(!ground) next_state = LFD;
                    else if(dig) next_state=LFG;
                    else if(bump_left) next_state=RT; 
                    else next_state=state;
                end
                RT:begin
                    if(!ground) next_state = RTD;
                    else if(dig) next_state=RTG;
                    else if(bump_right) next_state=LF;
                    else next_state=state;
                end
                LFD: next_state = ground?LF:LFD;
                RTD: next_state = ground?RT:RTD;
                LFG: next_state = (!ground)?LFD:LFG;
                RTG: next_state = (!ground)?RTD:RTG; 
            endcase
        end
    
    assign walk_left = (state==LF);
    assign walk_right = (state==RT);
    assign aaah = (state==LFD)|(state==RTD);
    assign digging = (state==LFG)|(state==RTG);
      

endmodule
