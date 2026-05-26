<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements an 8-bit maximal-period Linear Feedback Shift Register (LFSR). It uses XNOR feedback taps at positions 8, 6, 5, and 4 to generate a pseudo-random sequence of 255 distinct non-zero states. When the load seed control pin is pulled high, an external initialization value is stored into the internal registers.

## How to test

Provide a continuous system clock signal to the clock pin. Toggle the asynchronous active-low reset pin low to reset the counter state, then release it high. Observe the changing random binary combinations running across the parallel outputs.
## External Hardware

No specialized external PMOD boards are strictly required. For hardware verification and testing, the following can be used:
* **LEDs or Logic Analyzer:** Connected to `uo_out[7:0]` to visually verify the changing pseudo-random parallel byte patterns.
* **Oscilloscope or Logic Analyzer:** Connected to `uio_out[0]` to capture and monitor the serial data bitstream output.
* **Dip Switches / Push Buttons:** Connected to `ui_in[7:0]` to manually toggle control inputs and load custom seed initialization states.

