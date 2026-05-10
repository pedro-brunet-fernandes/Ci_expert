//Function: The test bench applies random values to 2-bit din and checks the decoded
//4-bit dout. The waveform decoder2x4_tb.vcd can be observed using waveform
//viewer.
//Test bench file: decoder2x4_tb.v

module decoder2x4_tb;

// Inputs
reg clk;
reg rstn;
reg en;
reg [1:0] din;

// Outputs
wire [3:0] dout;

// Self-check variables
integer error_count;
reg [255:0] vcd_file;

// clock generation
always #5 clk = ~clk; // toggle clock for every 5 ticks

// Task: check decoder
task check_decoder;
    input [3:0] exp_dout;
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
    din = 2'b00;
    error_count = 0;

    // Reset
    #10 rstn = 0;
    @(posedge clk);

    // Release reset
    #10 rstn = 1;
    @(posedge clk);

    // Enable
    en = 1;

    // Decode 0
    din = 2'b00;
    @(posedge clk);
    #1 check_decoder(4'b0001);

    // Decode 1
    din = 2'b01;
    @(posedge clk);
    #1 check_decoder(4'b0010);

    // Decode 2
    din = 2'b10;
    @(posedge clk);
    #1 check_decoder(4'b0100);

    // Decode 3
    din = 2'b11;
    @(posedge clk);
    #1 check_decoder(4'b1000);

    // Hold
    en = 0;
    din = 2'b00;
    @(posedge clk);
    #1 check_decoder(4'b1000);

    // Enable again
    en = 1;
    @(posedge clk);
    #1 check_decoder(4'b0001);

    // Final reset
    rstn = 0;
    en = 0;
    din = 2'b00;
    @(posedge clk);

    if (error_count == 0) begin
        $display("[PASS] All tests");
    end
    else begin
        $display("[FAIL] %0d error(s)", error_count);
    end

    #20 $finish;
end

decoder2x4 uut (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .din(din),
    .dout(dout)
);

initial begin
    if (!$value$plusargs("VCD=%s", vcd_file))
        vcd_file = "sim/decoder2x4.vcd";

    $dumpfile(vcd_file);
    $dumpvars(0, decoder2x4_tb);
end

endmodule