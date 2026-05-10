//Inputs: Nil
//Outputs: Nil
//Function: The test bench applies values to op_a and op_b operands and
//checks the result of addition by comparing the DUT output with the expected result.
//The waveform adder_tb.vcd is written out and can be observed using waveform viewer.
//Test Bench File: 32bit_adder_tb.v

module adder_tb;
  //---------------- Inputs--------
  reg clk;
  reg reset_n;
  reg en;
  reg [31:0] A;
  reg [31:0] B;

  //------------------ Outputs-----------
  wire [31:0] sum;
  wire carry_out;

  //-------check variables--------
  reg [32:0] expected;
  integer errors;

  // clock generation
  always #5 clk = ~clk; // toggle clock for every 5 ticks

  //self check
  task check_ad;
    input [31:0] A_test;
    input [31:0] B_test;
    begin
      A = A_test;
      B = B_test;

      expected = {1'b0, A_test} + {1'b0, B_test};

      @(posedge clk);
      #1;

      if ({carry_out, sum} !== expected) begin
        $display("ERRO: A=%h B=%h | esperado carry=%b sum=%h | obtido carry=%b sum=%h",
                 A_test, B_test,
                 expected[32], expected[31:0],
                 carry_out, sum);
        errors = errors + 1;
      end else begin
        $display("OK: A=%h B=%h | carry=%b sum=%h",
                 A_test, B_test, carry_out, sum);
      end
    end
  endtask

  initial begin
    clk = 0;
    reset_n = 1;
    en = 0;
    A = 32'd0;
    B = 32'd0;
    errors = 0;

    $display("--------- Test Started ---------");

    #10 reset_n = 0;
    #10 reset_n = 1;
    en = 1;

    $display("");
    $display("========= TESTES COM CARRY_OUT = 1 =========");

    $display("[CASO 1 - COM CARRY] A = 32'hFFFFFFFF | B = 32'h00000001");
    check_ad(32'hFFFFFFFF, 32'h00000001);
    // Esperado: carry_out = 1, sum = 32'h00000000

    #10;
    $display("[CASO 2 - COM CARRY] A = 32'hAAAAAAAA | B = 32'hEEEEEEEE");
    check_ad(32'hAAAAAAAA, 32'hEEEEEEEE);
    // Esperado: carry_out = 1, sum = 32'h99999998


    #10;
    $display("");
    $display("========= TESTES SEM CARRY_OUT =========");

    $display("[CASO 3 - SEM CARRY] A = 32'h00000010 | B = 32'h00000020");
    check_ad(32'h00000010, 32'h00000020);
    // Esperado: carry_out = 0, sum = 32'h00000030

    #10;
    $display("[CASO 4 - SEM CARRY] A = 32'h12345678 | B = 32'h11111111");
    check_ad(32'h12345678, 32'h11111111);
    // Esperado: carry_out = 0, sum = 32'h23456789

    
    if (errors == 0)
      $display("TESTE PASSOU: nenhum erro encontrado.");
    else
      $display("TESTE FALHOU: %0d erro(s) encontrado(s).", errors);

    #10;
    $finish;
  end

  //module instantiation
  adder u_adder(
    .clk(clk),
    .reset_n(reset_n),
    .en(en),
    .op_a(A),
    .op_b(B),
    .adder_out(sum),
    .carry_out(carry_out)
  );

  reg [8*200:1] vcd_name;

  initial begin
    if (!$value$plusargs("VCD=%s", vcd_name))
      vcd_name = "sim/adder32.vcd";

    $display("[TB] VCD file = %0s", vcd_name);
    $dumpfile(vcd_name);
    $dumpvars(0, adder_tb);
  end

endmodule