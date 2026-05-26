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

    // Main 8-bit registers that map directly to the physical chip outputs
    reg [7:0] uo_out_reg;
    reg [7:0] uio_out_reg;
    reg [7:0] uio_oe_reg;

    // Connect our physical output pin buses straight to the registers
    assign uo_out  = uo_out_reg;
    assign uio_out = uio_out_reg;
    assign uio_oe  = uio_oe_reg;

    // Core hardware anchor string using a reduction XOR operator.
    // This squashes ALL mandatory unused inputs into a single bit trace.
    wire input_anchor;
    assign input_anchor = ena ^ (^ui_in) ^ (^uio_in);

    // One unified sequential block to preserve 'clk' and 'rst_n'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active-low initialization reset states
            uo_out_reg  <= 8'hAC; // Non-zero start value for LFSR operation
            uio_out_reg <= 8'h00;
            uio_oe_reg  <= 8'h00;
        end else begin
            // 1. Force the output ports to depend on the input anchor inside the clock cycle.
            // This guarantees clk, rst_n, and all IO buses CANNOT be optimized out!
            uio_out_reg <= {8{input_anchor}};
            uio_oe_reg  <= 8'h00;

            // 2. Maximum-Period 8-bit LFSR sequence generator mapping directly onto uo_out
            if (ui_in[0]) begin
                uo_out_reg <= {ui_in[7:1], 1'b1}; // Seed load condition
            end else begin
                // XNOR Feedback Taps: 8, 6, 5, 4 (using indexes 7, 5, 4, 3) mixed with our anchor
                uo_out_reg <= {uo_out_reg[6:0], uo_out_reg[7] ^~ uo_out_reg[5] ^~ uo_out_reg[4] ^~ uo_out_reg[3]} ^ {8{input_anchor}};
            end
        end
    end

endmodule
