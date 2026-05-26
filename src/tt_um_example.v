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

    // Internal LFSR register register
    reg [7:0] lfsr_reg;
    
    // Wire assignments for outputs
    assign uo_out = lfsr_reg;   // Parallel output
    
    // Assign unused bi-directional IOs to 0 and set them as inputs
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // LFSR Sequential Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active-low reset initialization state (cannot be 0)
            lfsr_reg <= 8'hAC; 
        end else if (ui_in[0]) begin
            // When Load Seed Control Flag (ui_in[0]) is High, load seed from ui_in[7:1]
            lfsr_reg <= {ui_in[7:1], 1'b1}; // Ensure non-zero seed loading
        end else begin
            // Feedback shift logic using maximum period XNOR taps (Taps: 8, 6, 5, 4)
            lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^~ lfsr_reg[5] ^~ lfsr_reg[4] ^~ lfsr_reg[3]};
        end
    end

endmodule
