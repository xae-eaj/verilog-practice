`timescale 1ns/1ps

module tb_AND21;
    // inputs
    reg a, b;
    // output
    wire y;

    // instantiate the Unit Under Test (UUT)
    AND21 uut   (
        a,b,y
    );

    initial begin

        $dumpfile("AND21.vcd");
        $dumpvars(0, tb_AND21);
        $monitor("%5t  %b %b | %b", $time, a, b, y);

        //initialize Inputs
        a=0; b=0;

        // Add stimulus here
        #20 a=1; b=1;
        #20 a=1; b=0;
        #20 a=1; b=1;
        #20 a=0; b=1;
        #20 $finish;
    end

endmodule