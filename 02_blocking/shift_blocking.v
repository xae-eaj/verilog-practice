module shift_blocking (
    input  wire clk,
    input  wire rst_n,
    input  wire din,
    output reg  q1,
    output reg  q2,
    output reg  q3
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q1 = 1'b0;
            q2 = 1'b0;
            q3 = 1'b0;
        end else begin
            q1 = din;
            q2 = q1;
            q3 = q2;
        end
    end
endmodule