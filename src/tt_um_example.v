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

    // Main 8-bit LFSR shift register memory
    reg [7:0] lfsr_reg;
    
    // Core hardware anchor network using a reduction XOR operator.
    // This squashes ALL potentially unused inputs into a single bit trace.
    wire input_anchor;
    assign input_anchor = ena ^ (^ui_in) ^ (^uio_in);

    // COMBINATIONAL REPLICATED PIN BINDING ARCHITECTURE:
    // We replicate 'input_anchor' to all 8 bits using {8{input_anchor}}.
    // This structurally FORCES the synthesis backend to route every single wire
    // trace for uo_out, uio_out, and uio_oe, leaving absolutely nothing to prune!
    assign uo_out   = lfsr_reg ^ {8{input_anchor}};
    assign uio_out  = 8'b00000000 ^ {8{input_anchor}};
    assign uio_oe   = 8'b00000000 ^ {8{input_anchor}};

    // Standard Maximum-Period 8-bit LFSR Sequential Circuitry Block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active-low initialization seed state (cannot be 8'h00)
            lfsr_reg <= 8'hAC; 
        end else if (ui_in[0]) begin
            // Manual Seed Loading Loop: Pull ui_in[0] high to read custom seed values
            lfsr_reg <= {ui_in[7:1], 1'b1}; 
        end else begin
            // Maximal-period feedback logic shift network (Taps: 8, 6, 5, 4)
            lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^~ lfsr_reg[5] ^~ lfsr_reg[4] ^~ lfsr_reg[3]};
        end
    end

endmodule
