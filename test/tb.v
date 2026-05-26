`timescale 1ns/1ps

module tb;

    reg  [7:0] ui_in;
    wire [7:0] uo_out;

    reg  [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    reg ena;
    reg clk;
    reg rst_n;

    tt_um_raksha_lfsr dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("lfsr.vcd");
        $dumpvars(0, tb);

        clk    = 0;
        rst_n  = 0;
        ena    = 1;
        ui_in  = 8'b00000000;
        uio_in = 8'b00000000;

        // Reset
        #20;
        rst_n = 1;

        // Enable shifting
        ui_in[0] = 1;

        #200;

        // Load seed
        ui_in[1] = 1;
        ui_in[7:2] = 6'b101010;

        #10;
        ui_in[1] = 0;

        #200;

        $finish;
    end

endmodule
