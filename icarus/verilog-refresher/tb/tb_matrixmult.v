//Function: The test bench applies random values of A and B, and result is stored in
//32-bit Res. The waveform matrix2x2_mult_tb.vcd can be observed using waveform
//viewer.
//Test bench file: matrix2x2_mult_tb.v

module matrix2x2_mult_tb();

reg [31:0] A;
reg [31:0] B;
reg clk;
reg rstn;
reg en;

// Outputs
wire [31:0] Res;

// Self-check variables
integer error_count;
reg [255:0] vcd_file;

always #5 clk = ~clk;

// Task: check output
task check_output;
    input [31:0] exp_res;
    begin
        if (Res !== exp_res) begin
            $display("[FAIL] time=%0t | Res=%h expected=%h",
                     $time, Res, exp_res);

            error_count = error_count + 1;
        end
        else begin
            $display("[PASS] time=%0t | Res=%h",
                     $time, Res);
        end
    end
endtask

initial begin
    clk = 0;
    rstn = 0;
    en = 0;
    A = 0;
    B = 0;
    error_count = 0;

    // Reset
    #10 rstn = 0;
    @(posedge clk);

    // Release reset
    #10 rstn = 1;
    @(posedge clk);

    // Enable
    #10 en = 1;

    // Matrix 1
    A = 32'b00000001000000010000000100000001;
    B = 32'b00000001000000010000000100000001;
    @(posedge clk);
    #1 check_output(32'h02020202);

    // Matrix 2
    A = 32'b00000010000000100000001000000010;
    B = 32'b00000010000000100000001000000010;
    @(posedge clk);
    #1 check_output(32'h08080808);

    // Matrix 3
    A = 32'b00000001000000100000001100000100;
    B = 32'b00000001000000000000000000000001;
    @(posedge clk);
    #1 check_output(32'h01020304);

    // Matrix 4
    A = 32'b00000001000000100000001100000100;
    B = 32'b00000101000001100000011100001000;
    @(posedge clk);
    #1 check_output(32'h13162B32);

    // Hold
    en = 0;
    A = 32'b00001000000010000000100000001000;
    B = 32'b00001000000010000000100000001000;
    @(posedge clk);
    #1 check_output(32'h13162B32);

    // Enable again
    en = 1;
    @(posedge clk);
    #1 check_output(32'h80808080);

    // Final reset
    rstn = 0;
    en = 0;
    A = 0;
    B = 0;
    @(posedge clk);

    if (error_count == 0) begin
        $display("[PASS] All tests");
    end
    else begin
        $display("[FAIL] %0d error(s)", error_count);
    end

    #20 $finish;
end

matrix2x2_mult uut (
    .A(A),
    .B(B),
    .Res(Res),
    .clk(clk),
    .rstn(rstn),
    .en(en)
);

initial begin
    if (!$value$plusargs("VCD=%s", vcd_file))
        vcd_file = "sim/matrix2x2_mult_tb.vcd";

    $dumpfile(vcd_file);
    $dumpvars(0, matrix2x2_mult_tb);
end

endmodule