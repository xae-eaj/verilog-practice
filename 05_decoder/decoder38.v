module decoder38 (
    input  wire [2:0] sel,
    input  wire       en,
    output reg  [7:0] y
);

    always @(*) begin
        if (!en)
            y = 8'b0000_0000;
        else
            y = 8'b0000_0001 << sel;
    end

endmodule