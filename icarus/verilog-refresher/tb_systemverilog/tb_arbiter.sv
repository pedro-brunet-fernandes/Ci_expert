//==============================================================================
// File: arbiter_tb.v
// Description:
//   Simple testbench for the arbiter.
//   Applies requests from client1 and client2 and observes grants.
//==============================================================================

module arbiter_tb;

  // Inputs
  reg clk;
  reg reset_n;
  reg priority_sel;
  reg client1_req;
  reg client2_req;

  // Outputs
  wire o_grant1;
  wire o_grant2;

  // Self-check signals
  reg expected_grant1;
  reg expected_grant2;
  integer errors;



  // ////////////////////////////////Self-check task//////////////////////////////////////

  task check_arbiter;
      input expected_g1;
      input expected_g2;
      begin
          @(posedge clk);
          #1;

          expected_grant1 = expected_g1;
          expected_grant2 = expected_g2;

          if ((o_grant1 !== expected_grant1) || (o_grant2 !== expected_grant2)) begin
              $display("ERRO: t=%0t priority_sel=%b req1=%b req2=%b grant1=%b grant2=%b expected_g1=%b expected_g2=%b",
                       $time, priority_sel, client1_req, client2_req,
                       o_grant1, o_grant2, expected_grant1, expected_grant2);
              errors = errors + 1;
          end else begin
              $display("OK: t=%0t priority_sel=%b req1=%b req2=%b grant1=%b grant2=%b",
                       $time, priority_sel, client1_req, client2_req,
                       o_grant1, o_grant2);
          end
      end
  endtask





  //--------------------------------------------------------------------------
  // Clock generation
  //--------------------------------------------------------------------------
  initial begin
      clk = 1'b0;
      forever #5 clk = ~clk;
  end

  //--------------------------------------------------------------------------
  // DUT instantiation
  //--------------------------------------------------------------------------
  arbiter uu_arbiter (
      .clk         (clk),
      .reset_n     (reset_n),
      .priority_sel(priority_sel),
      .client1_req (client1_req),
      .client2_req (client2_req),
      .o_grant1    (o_grant1),
      .o_grant2    (o_grant2)
  );

  initial begin
      reset_n      = 1'b0;
      priority_sel = 1'b0;
      client1_req  = 1'b0;
      client2_req  = 1'b0;
      errors       = 0;

      // Reset
      #10 reset_n = 1'b0;
      #10 reset_n = 1'b1;

      check_arbiter(1'b0, 1'b0);

      // Case 1: client1 has priority
      @(posedge clk);
      #1;
      priority_sel = 1'b1;
      client1_req  = 1'b1;
      client2_req  = 1'b0;

      check_arbiter(1'b0, 1'b0);
      check_arbiter(1'b1, 1'b0);

      client1_req  = 1'b0;
      client2_req  = 1'b1;

      check_arbiter(1'b0, 1'b0);
      check_arbiter(1'b0, 1'b1);

      client1_req  = 1'b0;
      client2_req  = 1'b0;

      check_arbiter(1'b0, 1'b0);

      // Case 2: both request, client2 has priority
      priority_sel = 1'b0;
      client1_req  = 1'b1;
      client2_req  = 1'b1;

      check_arbiter(1'b0, 1'b0);
      check_arbiter(1'b0, 1'b1);
      check_arbiter(1'b1, 1'b0);

      client1_req  = 1'b0;
      client2_req  = 1'b0;

      check_arbiter(1'b0, 1'b0);

      // Case 3: both request, client1 has priority
      priority_sel = 1'b1;
      client1_req  = 1'b1;
      client2_req  = 1'b1;

      check_arbiter(1'b0, 1'b0);
      check_arbiter(1'b1, 1'b0);
      check_arbiter(1'b0, 1'b1);

      client1_req  = 1'b0;
      client2_req  = 1'b0;

      check_arbiter(1'b0, 1'b0);

      if (errors == 0)
          $display("TESTE FINALIZADO: todos os casos passaram.");
      else
          $display("TESTE FINALIZADO: %0d erro(s) encontrado(s).", errors);

      #10 $finish;
  end

  //--------------------------------------------------------------------------
  // Dump
  //--------------------------------------------------------------------------
  initial begin
      $dumpfile("sim/arbiter.vcd");
      $dumpvars(0, arbiter_tb);
  end

endmodule