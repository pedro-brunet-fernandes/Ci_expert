//Inputs: Nil
//Outputs: Nil
//Function: The test bench applies random values of op_a and op_b, and result is
//stored in 32-bit register. The waveform multiplier_tb.vcd can be observed using
//waveform viewer.
//Test bench file: multiplier_tb.v

module multiplier_tb;

reg clk;
reg reset_n;
reg en;
reg [15:0] op_a;
reg [15:0] op_b;
wire [31:0] multi_out;

// Self-check variables
integer error_count;
reg [255:0] vcd_file;

multiplier u1 (clk, reset_n, en, op_a, op_b, multi_out);

always #5 clk = ~clk;

// Task: check multiplier
task check_multiplier;
    input [31:0] exp_multi_out;
    begin
        if (multi_out !== exp_multi_out) begin
            $display("[FAIL] time=%0t | multi_out=%h expected=%h",
                     $time, multi_out, exp_multi_out);

            error_count = error_count + 1;
        end
        else begin
            $display("[PASS] time=%0t | multi_out=%h",
                     $time, multi_out);
        end
    end
endtask

initial
begin
    clk = 0;
    reset_n = 0;
    en = 0;
    op_a = 0;
    op_b = 0;
    error_count = 0;

    // Reset
    #10 reset_n = 0;
    @(posedge clk);

    // Release reset
    #10 reset_n = 1;
    @(posedge clk);

    // Multiply 1
    en = 1;
    op_a = 16'hAAAA;
    op_b = 16'hBBBB;
    @(posedge clk);
    #1 check_multiplier(32'h7D26D82E);

    // Multiply 2
    op_a = 16'h4444;
    op_b = 16'h1111;
    @(posedge clk);
    #1 check_multiplier(32'h048D0C84);

    // Multiply 3
    op_a = 16'h0002;
    op_b = 16'h0003;
    @(posedge clk);
    #1 check_multiplier(32'h00000006);

    // Multiply 4
    op_a = 16'h00FF;
    op_b = 16'h0002;
    @(posedge clk);
    #1 check_multiplier(32'h000001FE);

    // Hold
    en = 0;
    op_a = 16'hFFFF;
    op_b = 16'hFFFF;
    @(posedge clk);
    #1 check_multiplier(32'h000001FE);

    // Enable again
    en = 1;
    @(posedge clk);
    #1 check_multiplier(32'hFFFE0001);

    // Final reset
    reset_n = 0;
    en = 0;
    op_a = 0;
    op_b = 0;
    @(posedge clk);

    if (error_count == 0) begin
        $display("[PASS] All tests");
    end
    else begin
        $display("[FAIL] %0d error(s)", error_count);
    end

    #20 $finish;
end

initial
begin
    if (!$value$plusargs("VCD=%s", vcd_file))
        vcd_file = "sim/multiplier_tb.vcd";

    $dumpfile(vcd_file);
    $dumpvars(0, multiplier_tb);
end

endmodule