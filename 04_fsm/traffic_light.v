module traffic_light #(
    parameter GREEN_TIME  = 5,
    parameter YELLOW_TIME = 2,
    parameter RED_TIME    = 5
)(
    input  wire clk,
    input  wire rst_n,
    output reg  green,
    output reg  yellow,
    output reg  red
);

    localparam S_GREEN  = 2'd0;
    localparam S_YELLOW = 2'd1;
    localparam S_RED    = 2'd2;

    reg [1:0] state, next_state;
    reg [3:0] timer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S_GREEN;
        else
            state <= next_state;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            timer <= 4'd0;
        else if (state != next_state)
            timer <= 4'd0;
        else
            timer <= timer + 1'b1;
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_GREEN:  if (timer == GREEN_TIME  - 1) next_state = S_YELLOW;
            S_YELLOW: if (timer == YELLOW_TIME - 1) next_state = S_RED;
            S_RED:    if (timer == RED_TIME    - 1) next_state = S_GREEN;
            default:  next_state = S_GREEN;
        endcase
    end

    always @(*) begin
        green  = (state == S_GREEN);
        yellow = (state == S_YELLOW);
        red    = (state == S_RED);
    end

endmodule