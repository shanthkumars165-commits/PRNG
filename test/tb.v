`timescale 1ns / 1ps
`default_nettype none

module tb;

  // Declare testbench registers and wires
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  reg ena;
  reg clk;
  reg rst_n;

  // Instantiate the exact top module
  tt_um_example dut (
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  // System clock generator: 50MHz frequency loop (20ns period)
  always #10 clk = ~clk;

  initial begin
    // Setup wave file tracking for verification checks
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    // Initial system driving states
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 8'h00;
    uio_in = 8'h00;

    // Assert reset condition
    #40;
    rst_n = 1; 
    
    // Allow the LFSR to naturally iterate through states autonomously
    #1000;

    // Test loading an explicit seed value dynamically
    ui_in = 8'b10101011; // ui_in[0]=1 signals the module to load the top bits
    #20;
    ui_in = 8'b00000000; // Release the load flag back to regular generation mode
    
    // Run long enough to monitor serialization performance on uio_out[0]
    #2000;

    $display("Simulation complete. Check waves for non-repeating random distributions.");
    $finish;
  end

endmodule
