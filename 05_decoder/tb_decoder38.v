`timescale 1ns/1ps

module tb_decoder38;

    reg  [2:0] sel;
    reg        en;
    wire [7:0] y;

    integer error_count = 0;
    integer i;
    integer ones;
    integer b;

    decoder38 dut (.sel(sel), .en(en), .y(y));

    task check;
        input [7:0] expected;
        begin
            #1;
            if (y !== expected) begin
                $display("FAIL: en=%b sel=%b  expected=%b  got=%b",
                         en, sel, expected, y);
                error_count = error_count + 1;
            end else begin
                $display("PASS: en=%b sel=%b  y=%b", en, sel, y);
            end
        end
    endtask

    initial begin
        $dumpfile("decoder38.vcd");
        $dumpvars(0, tb_decoder38);

        // ① enable=0이면 sel과 무관하게 전부 0
        $display("--- enable off ---");
        en = 1'b0;
        for (i = 0; i < 8; i = i + 1) begin
            sel = i[2:0];
            check(8'b0000_0000);
        end

        // ② enable=1이면 sel 위치의 비트만 1
        $display("--- enable on ---");
        en = 1'b1;
        for (i = 0; i < 8; i = i + 1) begin
            sel = i[2:0];
            check(8'b0000_0001 << i);
        end

        // ③ 원-핫 성질 확인: 1인 비트가 정확히 하나인가
        $display("--- one-hot check ---");
        for (i = 0; i < 8; i = i + 1) begin
            sel = i[2:0];
            #1;
            ones = 0;
            for (b = 0; b < 8; b = b + 1)
                if (y[b]) ones = ones + 1;

            if (ones !== 1) begin
                $display("FAIL: sel=%b  y=%b  has %0d ones", sel, y, ones);
                error_count = error_count + 1;
            end else begin
                $display("PASS: sel=%b  exactly one bit set", sel);
            end
        end

        $display("-----------------------------");
        if (error_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", error_count);
        $display("-----------------------------");

        $finish;
    end
endmodule