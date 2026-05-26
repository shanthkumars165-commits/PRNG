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

    // Internal LFSR state register
    reg [7:0] lfsr_reg;
    
    // Assign parallel state to output pins
    assign uo_out = lfsr_reg;
    
    // Explicitly drive unused bidirectional IO buses to safe constants
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Sequential Clock Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr_reg <= 8'hAC; // Initialize with a non-zero start seed
        end else if (ui_in[0]) begin
            lfsr_reg <= {ui_in[7:1], 1'b1}; // Load customized seed when ui_in[0] is high
        end else begin
            // XNOR Taps at positions 8, 6, 5, 4 for maximal 255-state period
            lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^~ lfsr_reg[5] ^~ lfsr_reg[4] ^~ lfsr_reg[3]};
        end
    end

endmodule
