`timescale 1ns/1ps

module tb_blocking_compare;
    reg clk   = 0;
    reg rst_n = 0;
    reg din   = 0;

    wire nq1, nq2, nq3;    // non-blocking 버전 출력
    wire bq1, bq2, bq3;    // blocking 버전 출력

    shift_nonblocking u_nb (
        .clk(clk), .rst_n(rst_n), .din(din),
        .q1(nq1), .q2(nq2), .q3(nq3)
    );

    shift_blocking u_b (
        .clk(clk), .rst_n(rst_n), .din(din),
        .q1(bq1), .q2(bq2), .q3(bq3)
    );

    always #5 clk = ~clk;

    // 클럭마다 두 버전을 나란히 출력
    always @(posedge clk) begin
        #1;
        if (rst_n)
            $display("t=%3t  din=%b | NB: %b%b%b | B: %b%b%b",
                     $time, din, nq1, nq2, nq3, bq1, bq2, bq3);
    end

    initial begin
        $dumpfile("blocking_compare.vcd");
        $dumpvars(0, tb_blocking_compare);

        #12 rst_n = 1;

        @(negedge clk) din = 1'b1;   // 딱 한 클럭만 1
        @(negedge clk) din = 1'b0;

        repeat (6) @(posedge clk);
        $finish;
    end
endmodule