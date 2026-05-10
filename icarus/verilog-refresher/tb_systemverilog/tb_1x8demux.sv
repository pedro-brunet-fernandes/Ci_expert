//Function: The test bench applies random values to 3-bit select lines and checks the
//dout. The waveform demux_tb.vcd can be observed using waveform viewer.
//Test bench file: demux3x8_tb.v

module demux1x8_tb;

// Inputs
reg clk;
reg rstn;
reg en;
reg [2:0] sel;
reg din;

// Outputs
wire [7:0] dout;

//task input

integer errors;
reg [7:0] expected;

// clock generation
always #5 clk = ~clk; // toggle clock for every 5 ticks



//////////////////task self-check////

task demux_check;
    input teste_din;
    input [2:0] teste_sel;

    begin
        din = teste_din;
        sel = teste_sel;

        #10;

        expected = 8'b00000000;
        expected[teste_sel] = teste_din;

        if (dout !== expected) begin
            $display("ERRO: din=%b sel=%b dout=%b expected=%b",
                     teste_din, teste_sel, dout, expected);
            errors = errors + 1;
        end else begin
            $display("OK: din=%b sel=%b dout=%b",
                     teste_din, teste_sel, dout);
        end
    end
endtask

initial begin
    clk = 0;
    rstn = 0;
    en = 0;

    //$display("--------- Test Started ---------");

    #10 rstn = 0;
    #10 rstn = 1;

    en = 1;

    demux_check(1'b0, 3'b000);
    demux_check(1'b1, 3'b000);
    demux_check(1'b0, 3'b001);
    demux_check(1'b1, 3'b001);

    demux_check(1'b0, 3'b010);
    demux_check(1'b1, 3'b010);
    demux_check(1'b0, 3'b011);
    demux_check(1'b1, 3'b011);

    demux_check(1'b0, 3'b100);
    demux_check(1'b1, 3'b100);
    demux_check(1'b0, 3'b101);
    demux_check(1'b1, 3'b101);

    demux_check(1'b0, 3'b110);
    demux_check(1'b1, 3'b110);
    demux_check(1'b0, 3'b111);
    demux_check(1'b1, 3'b111);
    #100 $finish;
end

demux1x8 uut (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .sel(sel),
    .din(din),
    .dout(dout)
);

initial begin
    $dumpfile("sim/1x8demux.vcd");
    $dumpvars(0, demux1x8_tb);
end

endmodule