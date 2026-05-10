//Function: The test bench is the module where the counter_overflow is instantiated
//and test stimulus to be applied to the IO signals of the design are generated. During
//simulation, the stimulus generated are applied and design responses are captured.
//Signals enable and load are set appropriately and 32-bit counting sequence is
//verified. The waveform file counter_overflow_tb.vcd is written out during the simulation
//by the test bench, which can be observed using waveform viewer.
//Test bench file: counter_overflow_tb.v

module counter_overflow_tb;

// Inputs
reg clk;
reg reset_n;
reg en;
reg load;

// Outputs
wire [31:0] counter_out;
wire counter_overflow;

// Self-check variables
integer error_count;

// Clock generation
always
    #5 clk = ~clk;

// Task: check output
task check_output;
    input [31:0] exp_counter;
    input exp_overflow;
    begin
        if ((counter_out !== exp_counter) ||
            (counter_overflow !== exp_overflow)) begin

            $display("[FAIL] time=%0t | counter_out=%h expected=%h | overflow=%b expected=%b",
                     $time, counter_out, exp_counter,
                     counter_overflow, exp_overflow);

            error_count = error_count + 1;
        end
        else begin
            $display("[PASS] time=%0t | counter_out=%h | overflow=%b",
                     $time, counter_out, counter_overflow);
        end
    end
endtask

initial
begin
    clk = 0;
    reset_n = 0;
    en = 0;
    load = 0;
    error_count = 0;


    // Reset
    #10 reset_n = 0;
    @(posedge clk);
    #1 check_output(32'h00000000, 1'b0);

    // Release reset
    #10 reset_n = 1;
    @(posedge clk);
    #1 check_output(32'h00000000, 1'b0);

    // Count 1
    #10 en = 1;
    @(posedge clk);
    #1 check_output(32'h00000001, 1'b0);

    // Count 2
    @(posedge clk);
    #1 check_output(32'h00000002, 1'b0);

    // Load near overflow
    en = 0;
    load = 1;
    @(posedge clk);
    #1 check_output(32'hFFFFFFF8, 1'b1);

    // Count FFFFFFF9
    load = 0;
    en = 1;
    @(posedge clk);
    #1 check_output(32'hFFFFFFF9, 1'b1);

    // Count FFFFFFFA
    @(posedge clk);
    #1 check_output(32'hFFFFFFFA, 1'b1);

    // Count FFFFFFFB
    @(posedge clk);
    #1 check_output(32'hFFFFFFFB, 1'b1);

    // Count FFFFFFFC
    @(posedge clk);
    #1 check_output(32'hFFFFFFFC, 1'b1);

    // Count FFFFFFFD
    @(posedge clk);
    #1 check_output(32'hFFFFFFFD, 1'b1);

    // Count FFFFFFFE
    @(posedge clk);
    #1 check_output(32'hFFFFFFFE, 1'b1);

    // Count FFFFFFFF
    @(posedge clk);
    #1 check_output(32'hFFFFFFFF, 1'b1);

    // Overflow wrap
    @(posedge clk);
    #1 check_output(32'h00000000, 1'b0);

    // Count after overflow
    @(posedge clk);
    #1 check_output(32'h00000001, 1'b0);

    if (error_count == 0) begin
        $display("[PASS] All tests");
    end
    else begin
        $display("[FAIL] %0d error(s)", error_count);
    end

    #20 $finish;
end

counter_overflow uut (
    .clk(clk),
    .reset_n(reset_n),
    .en(en),
    .counter_out(counter_out),
    .counter_overflow(counter_overflow),
    .load(load)
);

initial
begin
    $dumpfile("sim/counter32bit.vcd");
    $dumpvars(0, counter_overflow_tb);
end

endmodule