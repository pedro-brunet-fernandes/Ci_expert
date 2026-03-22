
module tb_top();



    logic a, b, c;

    dut uut (
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        $display("a b | c");

        a = 0; b = 0; #1;
        $display("%0d %0d | %0d", a, b, c);

        a = 0; b = 1; #1;
        $display("%0d %0d | %0d", a, b, c);

        a = 1; b = 0; #1;
        $display("%0d %0d | %0d", a, b, c);

        a = 1; b = 1; #1;
        $display("%0d %0d | %0d", a, b, c);

        $finish;
    end

endmodule
