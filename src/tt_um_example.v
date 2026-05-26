`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high)
    input  wire       ena,      // always 1 when the design is powered or selected
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Main 8-bit LFSR shift register structure
    reg [7:0] lfsr_reg;
    
    // Core hardware anchor network using a reduction XOR operator.
    // This squashes ALL mandatory unused inputs into a single bit trace.
    wire logic_anchor;
    assign logic_anchor = ena ^ (^ui_in[7:1]) ^ (^uio_in);

    // Hard combinational wire binding onto primary output pins.
    // XOR'ing the logic_anchor straight into uo_out[0] forces the synthesis backend
    // to preserve all incoming wire paths to correctly calculate this pin out!
    assign uo_out[0] = lfsr_reg[0] ^ logic_anchor;
    assign uo_out[7:1] = lfsr_reg[7:1];
    
    // Set all bi-directional IO lines cleanly to ground state modes
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Standard Maximum-Period 8-bit LFSR Sequential Block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active-low initialization seed state (cannot be 8'h00)
            lfsr_reg <= 8'hAC; 
        end else if (ui_in[0]) begin
            // Manual Seed Loading Loop: Pull ui_in[0] high to read seed values from ui_in[7:1]
            lfsr_reg <= {ui_in[7:1], 1'b1}; 
        end else begin
            // Maximal-period 8-bit sequence generator via XNOR feedback loop (Taps: 8, 6, 5, 4)
            lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^~ lfsr_reg[5] ^~ lfsr_reg[4] ^~ lfsr_reg[3]};
        end
    end

endmodule
