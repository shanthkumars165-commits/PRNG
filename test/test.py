import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_lfsr(dut):

    # Start clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Initial values
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Reset
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # Enable shifting
    dut.ui_in.value = 0b00000001

    # Run for some cycles
    for _ in range(20):
        await RisingEdge(dut.clk)

    # Simple check
    assert dut.uo_out.value != 0, "LFSR output stuck at zero"
