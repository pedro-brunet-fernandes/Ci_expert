//Function: The test bench applies random values to 4-bit din and checks the encoded
//2-bit dout. The waveform encoder4x2_tb.vcd can be observed using waveform
//viewer.
//Test bench file: encoder4x2_tb.v

module encoder4x2_tb;

// Inputs
reg [3:0] din;
reg en;
reg clk;
reg rstn;

// Outputs
wire [1:0] dout;

// Self-check variables
integer error_count;
reg [255:0] vcd_file;

// clock generation
always #5 clk = ~clk; // toggle clock for every 5 ticks

// Task: check output
task check_output;
    input [1:0] exp_dout;
    begin
        if (dout !== exp_dout) begin
            $display("[FAIL] time=%0t | dout=%b expected=%b",
                     $time, dout, exp_dout);

            error_count = error_count + 1;
        end
        else begin
            $display("[PASS] time=%0t | dout=%b",
                     $time, dout);
        end
    end
endtask

initial begin
    // Initialize Inputs
    clk = 0;
    rstn = 1;
    en = 0;
    din = 4'b0000;
    error_count = 0;

    // Reset
    #10 rstn = 0;
    @(posedge clk);

    // Release reset
    #10 rstn = 1;
    @(posedge clk);

    // Enable
    en = 1;

    // Encode 0
    din = 4'b0001;
    @(posedge clk);
    #1 check_output(2'b00);

    // Encode 1
    din = 4'b0010;
    @(posedge clk);
    #1 check_output(2'b01);

    // Encode 2
    din = 4'b0100;
    @(posedge clk);
    #1 check_output(2'b10);

    // Encode 3
    din = 4'b1000;
    @(posedge clk);
    #1 check_output(2'b11);

    // Hold
    en = 0;
    din = 4'b0001;
    @(posedge clk);
    #1 check_output(2'b11);

    // Enable again
    en = 1;
    @(posedge clk);
    #1 check_output(2'b00);

    // Final reset
    rstn = 0;
    en = 0;
    din = 4'b0000;
    @(posedge clk);

    if (error_count == 0) begin
        $display("[PASS] All tests");
    end
    else begin
        $display("[FAIL] %0d error(s)", error_count);
    end

    #20 $finish;
end

encoder4x2 uut (
    .clk(clk),
    .din(din),
    .dout(dout),
    .rstn(rstn),
    .en(en)
);

initial begin
    if (!$value$plusargs("VCD=%s", vcd_file))
        vcd_file = "sim/encoder4x2_tb.vcd";

    $dumpfile(vcd_file);
    $dumpvars(0, encoder4x2_tb);
end

endmodule