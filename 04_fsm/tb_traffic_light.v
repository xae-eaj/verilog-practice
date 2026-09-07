`timescale 1ns/1ps

module tb_traffic_light;

    localparam GREEN_TIME  = 5;
    localparam YELLOW_TIME = 2;
    localparam RED_TIME    = 5;

    localparam P_GREEN  = 3'b100;
    localparam P_YELLOW = 3'b010;
    localparam P_RED    = 3'b001;

    reg  clk   = 0;
    reg  rst_n = 0;
    wire green, yellow, red;

    integer   error_count = 0;
    integer   len;
    reg [2:0] pat;

    traffic_light #(
        .GREEN_TIME(GREEN_TIME),
        .YELLOW_TIME(YELLOW_TIME),
        .RED_TIME(RED_TIME)
    ) dut (
        .clk(clk), .rst_n(rst_n),
        .green(green), .yellow(yellow), .red(red)
    );

    always #5 clk = ~clk;

    task measure_phase;
        begin
            pat = {green, yellow, red};
            len = 0;
            while ({green, yellow, red} === pat) begin
                len = len + 1;
                @(negedge clk);
            end
        end
    endtask

    task check_phase;
        input [2:0]   exp_pat;
        input integer exp_len;
        begin
            if (pat !== exp_pat || len !== exp_len) begin
                $display("FAIL: pattern=%b len=%0d   (expected %b len=%0d)",
                         pat, len, exp_pat, exp_len);
                error_count = error_count + 1;
            end else begin
                $display("PASS: pattern=%b len=%0d", pat, len);
            end
        end
    endtask

    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light);

        #12 rst_n = 1;
        @(negedge clk);

        measure_phase;
        $display("(skip) first partial phase: pattern=%b len=%0d", pat, len);

        measure_phase; check_phase(P_YELLOW, YELLOW_TIME);
        measure_phase; check_phase(P_RED,    RED_TIME);
        measure_phase; check_phase(P_GREEN,  GREEN_TIME);
        measure_phase; check_phase(P_YELLOW, YELLOW_TIME);
        measure_phase; check_phase(P_RED,    RED_TIME);
        measure_phase; check_phase(P_GREEN,  GREEN_TIME);

        $display("-----------------------------");
        if (error_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", error_count);
        $display("-----------------------------");

        $finish;
    end
endmodule