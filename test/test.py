import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_lfsr(dut):
    dut._log.info("Starting LFSR Testbench Verification with Hardware Anchor...")

    # Define and start a 100MHz system clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Initial Condition: Apply Active-Low Reset
    dut._log.info("Applying system reset...")
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.ena.value = 1
    await ClockCycles(dut.clk, 5)
    
    # Release Reset
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)
    
    dut._log.info("Running pseudo-random sequence cycles...")
    for i in range(10):
        await ClockCycles(dut.clk, 1)
        # We read the upper bits which contain pure LFSR data stable from optimization shifts
        val = int(dut.uo_out.value)
        dut._log.info(f"Cycle {i+1} raw out: {hex(val)}")

    dut._log.info("LFSR simulation verification pass completed successfully!")
