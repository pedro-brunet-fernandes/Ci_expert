//Inputs: Nil
//Outputs: Nil
//Function: The test bench applies random values and checks the result of counting.
//The waveform updown_counter_tb.vcd can be observed using waveform viewer.
//Test bench file: updown_counter_tb.v

module updown_counter_tb;

// Inputs
reg clk;
reg resetn;
reg en;

// Outputs
wire [3:0] up_counter;
wire [3:0] down_counter;

// Self-check variables
integer error_count;
reg [255:0] vcd_file;

// clock generation
always #5 clk = ~clk; // toggle clock for every 5 ticks

// Task: check output
task check_output;
    input [3:0] exp_up;
    input [3:0] exp_down;
    begin
        if ((up_counter !== exp_up) ||
            (down_counter !== exp_down)) begin

            $display("[FAIL] time=%0t | up=%h expected=%h | down=%h expected=%h",
                     $time, up_counter, exp_up,
                     down_counter, exp_down);

            error_count = error_count + 1;
        end
        else begin
            $display("[PASS] time=%0t | up=%h | down=%h",
                     $time, up_counter, down_counter);
        end
    end
endtask

initial begin
    // Initialize Inputs
    clk = 0;
    resetn = 1;
    en = 0;
    error_count = 0;

    // Reset active
    #10 resetn = 0;
    @(posedge clk);
    #1 check_output(4'h0, 4'hF);

    // Release reset
    #10 resetn = 1;
    @(posedge clk);
    #1 check_output(4'h0, 4'hF);

    // Count 1
    en = 1;
    @(posedge clk);
    #1 check_output(4'h1, 4'hE);

    // Count 2
    @(posedge clk);
    #1 check_output(4'h2, 4'hD);

    // Count 3
    @(posedge clk);
    #1 check_output(4'h3, 4'hC);

    // Count 4
    @(posedge clk);
    #1 check_output(4'h4, 4'hB);

    // Hold 1
    en = 0;
    @(posedge clk);
    #1 check_output(4'h4, 4'hB);

    // Hold 2
    @(posedge clk);
    #1 check_output(4'h4, 4'hB);

    // Count again 1
    en = 1;
    @(posedge clk);
    #1 check_output(4'h5, 4'hA);

    // Count again 2
    @(posedge clk);
    #1 check_output(4'h6, 4'h9);

    // Count again 3
    @(posedge clk);
    #1 check_output(4'h7, 4'h8);

    // Count again 4
    @(posedge clk);
    #1 check_output(4'h8, 4'h7);

    // Final reset
    resetn = 0;
    en = 0;
    @(posedge clk);
    #1 check_output(4'h0, 4'hF);

    if (error_count == 0) begin
        $display("[PASS] All tests");
    end
    else begin
        $display("[FAIL] %0d error(s)", error_count);
    end

    #20 $finish;
end

updowncounter uut (
    .clk(clk),
    .resetn(resetn),
    .en(en),
    .up_counter(up_counter),
    .down_counter(down_counter)
);

initial begin
    if (!$value$plusargs("VCD=%s", vcd_file))
        vcd_file = "sim/updown_counter.vcd";

    $dumpfile("sim/updown_counter.vcd");
    $dumpvars(0, updown_counter_tb);
end

endmodule