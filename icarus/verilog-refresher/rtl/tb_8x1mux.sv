//Function: The test bench applies random values to 3-bit select lines and checks the
//dout. The waveform mux8x1_tb.vcd can be observed using waveform viewer.
//Test bench file: mux8x1_tb.v

module mux8x1_tb;

// Inputs
reg clk;
reg rstn;
reg en;
reg [7:0] din;
reg [2:0] sel;

// Outputs
wire dout;

//tasks

reg expected;
integer errors;

// clock generation
always #5 clk = ~clk; // toggle clock for every 5 ticks

/////////////task de self check////////////////////////

    task check_mux;
        
    input [7:0] test_din;
    input [2:0] test_sel;
    begin
        din = test_din;
        sel = test_sel;

        #10;
        expected = 8'b00000000;

        expected = test_din[test_sel];

        if (dout !== expected) begin
            $display("ERRO: sel=%b din=%b dout=%b esperado=%b",
                     test_sel, test_din, dout, expected);
            errors = errors + 1;
        end else begin
            $display("OK: sel=%b din=%b dout=%b",
                     test_sel, test_din, dout);
        end
    end
    endtask

//////////////////////////////////////////////////////////////

initial begin
    // Initialize Inputs
    clk = 0;
    rstn = 1;
    en = 0;

    #10 rstn = 0;
    #10 rstn = 1;

    en = 1;

    check_mux(8'b00000000, 3'b000);
    check_mux(8'b00000000, 3'b001);
    check_mux(8'b00000000, 3'b010);
    check_mux(8'b00000000, 3'b011);

    check_mux(8'b00010000, 3'b100);
    check_mux(8'b00100000, 3'b101);
    check_mux(8'b01000000, 3'b110);
    check_mux(8'b10000000, 3'b111);
    check_mux(8'b00000000, 3'b000);
    check_mux(8'b00000001, 3'b000);
    check_mux(8'b00000010, 3'b000);
    check_mux(8'b00000010, 3'b001);

    #100 $finish;
end

mux8x1 uut (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .din(din),
    .sel(sel),
    .dout(dout)
);

initial begin
    $dumpfile("sim/8x1mux.vcd");
    $dumpvars(0, mux8x1_tb);
end

endmodule