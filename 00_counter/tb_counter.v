`timescale 1ns/1ps

module tb_counter;
    reg        clk = 0;
    reg        rst_n = 0;
    wire [3:0] cnt;

    counter dut (.clk(clk), .rst_n(rst_n), .cnt(cnt));

    always #5 clk = ~clk;              // 10ns 주기 클럭 생성

    initial begin
        $dumpfile("counter.vcd");      // 파형 파일 이름 지정
        $dumpvars(0, tb_counter);      // 모든 신호를 파형에 기록

        #12 rst_n = 1;                 // 12ns 후 리셋 해제
        #200 $finish;                  // 212ns에 종료
    end

    initial
        $monitor("time=%0t  cnt=%d", $time, cnt);
    // 신호가 바뀔 때마다 터미널에 출력
endmodule