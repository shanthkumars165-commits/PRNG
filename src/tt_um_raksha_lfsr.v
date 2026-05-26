module tt_um_raksha_lfsr (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    reg [7:0] lfsr;

    // Tell synthesis these are intentionally unused
    wire _unused = &{ena, uio_in, 1'b0};

    // Feedback polynomial:
    // x^8 + x^6 + x^5 + x^4 + 1

    wire feedback;
    assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 8'b00000001;

        else if (ui_in[1])
            lfsr <= {2'b00, ui_in[7:2]};

        else if (ui_in[0])
            lfsr <= {lfsr[6:0], feedback};
    end

    assign uo_out = lfsr;

    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

endmodule
