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
   
  
  //参数说明：
  //drop_cnt为下落时间计时，若drop_cnt>=20，落地即死
  //g20为drop_cnt>=20的标志
    parameter LF=0,RT=1,LFD=2,RTD=3,LFG=4,RTG=5,DEAD=6;
    reg [2:0] state, next_state;
    reg [4:0] drop_cnt;
    reg g20;
    
    always@(posedge clk or posedge areset)
        begin
            if (areset) 
                drop_cnt <= 0;
            else if (ground)
                drop_cnt <= 0;
            else
                drop_cnt <= drop_cnt+1;
        end
   
  //previous: assign g20=(drop_cnt>=20)
  //error
  //猜测原因，使用assign时，ground=1时，g20=0，在状态转移中差了一个周期
  //小人永远不会死了
    always@(posedge clk or posedge areset)
        begin
            if (areset) 
                g20 <= 0;
            else if (drop_cnt>=5'd20)
                g20 <= 1;
            else 
                g20 <= g20;
        end
    
    always @(posedge clk or posedge areset)
        begin
            if(areset)
                state <= LF;
            else
                state <= next_state;
        end
    
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
                LFD: next_state = (g20&ground)?DEAD:(ground?LF:LFD);
                RTD: next_state = (g20&ground)?DEAD:(ground?RT:RTD);
                LFG: next_state = (!ground)?LFD:LFG;
                RTG: next_state = (!ground)?RTD:RTG; 
                DEAD:next_state = state;
            endcase
        end
    
    always@(*)
        begin
            case(state)
                LF: {walk_left,walk_right,aaah,digging}=4'b1000;
                RT: {walk_left,walk_right,aaah,digging}=4'b0100;
                LFD: {walk_left,walk_right,aaah,digging}=4'b0010;
                RTD: {walk_left,walk_right,aaah,digging}=4'b0010;
                LFG: {walk_left,walk_right,aaah,digging}=4'b0001;
                RTG: {walk_left,walk_right,aaah,digging}=4'b0001;
                DEAD: {walk_left,walk_right,aaah,digging}=4'b0000;
                default: {walk_left,walk_right,aaah,digging}=4'b0000;
            endcase
        end

endmodule
