/*
 * Copyright (c) 2026 Raksha S S
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs: ui_in[0] acts as a Load Seed signal
                                // ui_in[7:1] can be an optional initial seed value
    output wire [7:0] uo_out,   // Dedicated outputs: Parallel random byte out
    input  wire [7:0] uio_in,   // IOs: Input path (Unused)
    output wire [7:0] uio_out,  // IOs: Output path: uio_out[0] is Serial Data Out
    output wire [7:0] uio_oe,   // IOs: Enable path (1 = output, 0 = input)
    input  wire       ena,      // Always 1 when design is powered
    input  wire       clk,      // Clock signal
    input  wire       rst_n     // Active-low asynchronous reset
);

  // Internal 8-bit shift register state
  reg [7:0] lfsr_reg;

  // XNOR feedback taps for a maximal-period 8-bit LFSR (Taps: 8, 6, 5, 4)
  // This structure ensures it cycles through 255 unique non-zero states before repeating.
  wire feedback = ~(lfsr_reg[7] ^ lfsr_reg[5] ^ lfsr_reg[4] ^ lfsr_reg[3]);

  // Sequential state transition logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // LFSR must never be initialized to all 1s if using XNOR feedback loop (causes lockup)
      // We initialize it to an alternative distinct reset state
      lfsr_reg <= 8'h00; 
    end else if (ui_in[0]) begin
      // If load seed pin is active, load external value to jump-start the pattern
      lfsr_reg <= {ui_in[7:1], 1'b0};
    end else begin
      // Shift left and insert the feedback bit at the LSB position
      lfsr_reg <= {lfsr_reg[6:0], feedback};
    end
  end

  // Assign the complete 8-bit parallel state to dedicated outputs
  assign uo_out = lfsr_reg;

  // Assign bit 0 of bi-directional pins as a dedicated Serial stream out
  assign uio_out = {7'b0000000, lfsr_reg[7]};
  
  // Set Pin Direction: Configures uio[0] as Output (1), and uio[7:1] as Inputs (0)
  assign uio_oe  = 8'b00000001;

  // Safeguard unused pins to clear compiler warnings
  wire _unused = &{ena, ui_in[0], uio_in, 1'b0};

endmodule
