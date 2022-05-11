module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    parameter IDLE=0,DATA1=1,DATA10=2;
    reg [1:0] state,next;
    
    always@(posedge clk or negedge aresetn)
        begin
            if(!aresetn) state <= IDLE;
            else         state <= next;
        end
    
    always@(*)
        begin
            case(state)
                IDLE:   next=x?DATA1:IDLE;
                DATA1:  next=x?DATA1:DATA10;
                DATA10: next=x?DATA1:IDLE;
                default:next=IDLE;
            endcase
        end
    
    assign z = (state==DATA10)&x;

endmodule
