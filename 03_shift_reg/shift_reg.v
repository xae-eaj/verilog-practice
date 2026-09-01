module shift_reg #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             load,
    input  wire [WIDTH-1:0] load_data,
    input  wire             shift_en,
    input  wire             serial_in,
    output wire             serial_out,
    output reg  [WIDTH-1:0] data
);

    assign serial_out = data[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data <= {WIDTH{1'b0}};
        else if (load)
            data <= load_data;
        else if (shift_en)
            data <= {serial_in, data[WIDTH-1:1]};
    end

endmodule