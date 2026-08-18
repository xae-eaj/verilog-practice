`timescale 1ns/1ps

module tb_mux4;
    reg  [3:0] d0, d1, d2, d3;
    reg  [1:0] sel;
    wire [3:0] y;

    integer error_count = 0;

    mux4 dut (.d0(d0), .d1(d1), .d2(d2), .d3(d3), .sel(sel), .y(y));

    // 기대값과 실제값을 비교하는 검사 태스크
    task check;
        input [3:0] expected;
        begin
            #1;  // 조합회로 안정화 대기
            if (y !== expected) begin
                $display("FAIL: sel=%b  expected=%h  got=%h", sel, expected, y);
                error_count = error_count + 1;
            end else begin
                $display("PASS: sel=%b  y=%h", sel, y);
            end
        end
    endtask

    initial begin
        $dumpfile("mux4.vcd");
        $dumpvars(0, tb_mux4);

        d0 = 4'hA; d1 = 4'hB; d2 = 4'hC; d3 = 4'hD;

        sel = 2'b00; check(4'hA);
        sel = 2'b01; check(4'hB);
        sel = 2'b10; check(4'hC);
        sel = 2'b11; check(4'hD);

        // 입력값을 바꿔서 한 번 더
        d0 = 4'h1; d1 = 4'h2; d2 = 4'h3; d3 = 4'h4;

        sel = 2'b00; check(4'h1);
        sel = 2'b11; check(4'h4);

        $display("-----------------------------");
        if (error_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", error_count);
        $display("-----------------------------");

        $finish;
    end
endmodule