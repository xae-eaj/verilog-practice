`timescale 1ns/1ps

module tb_shift_reg;

    parameter WIDTH = 8;

    reg              clk       = 0;
    reg              rst_n     = 0;
    reg              load      = 0;
    reg  [WIDTH-1:0] load_data = 0;
    reg              shift_en  = 0;
    reg              serial_in = 0;
    wire             serial_out;
    wire [WIDTH-1:0] data;

    integer          error_count = 0;
    integer          i;
    reg  [WIDTH-1:0] tx_byte;
    reg  [WIDTH-1:0] received;

    shift_reg #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst_n(rst_n),
        .load(load), .load_data(load_data),
        .shift_en(shift_en), .serial_in(serial_in),
        .serial_out(serial_out), .data(data)
    );

    always #5 clk = ~clk;

    task check_data;
        input [WIDTH-1:0] expected;
        begin
            if (data !== expected) begin
                $display("FAIL: expected=%h  got=%h", expected, data);
                error_count = error_count + 1;
            end else begin
                $display("PASS: data=%h", data);
            end
        end
    endtask

    initial begin
        $dumpfile("shift_reg.vcd");
        $dumpvars(0, tb_shift_reg);

        tx_byte = 8'hA5;              // 1010_0101

        #12 rst_n = 1;

        // ① 리셋 확인
        @(negedge clk);
        check_data(8'h00);

        // ② 병렬 로드
        load = 1; load_data = tx_byte;
        @(negedge clk);
        load = 0;
        check_data(tx_byte);

        // ③ LSB부터 한 비트씩 밀어내기
        $display("--- shifting out (LSB first) ---");
        shift_en  = 1;
        serial_in = 1'b1;             // UART idle 상태가 1이라 1로 채움

        for (i = 0; i < WIDTH; i = i + 1) begin
            received[i] = serial_out;
            $display("bit %0d : serial_out=%b   data=%b", i, serial_out, data);
            @(negedge clk);
        end

        shift_en = 0;

        // ④ 보낸 바이트와 받은 비트열이 같은가
        if (received !== tx_byte) begin
            $display("FAIL: sent=%h  received=%h", tx_byte, received);
            error_count = error_count + 1;
        end else begin
            $display("PASS: serial stream = %h (LSB first)", received);
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