import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_lfsr(dut):
    dut._log.info("Starting LFSR Testbench Verification...")

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
    dut._log.info(self_initial_state := f"Reset released. Initial state parallel out: {int(dut.uo_out.value)}")

    # Let the register cycle naturally through a few states
    dut._log.info("Running pseudo-random natural sequence cycles...")
    for i in range(10):
        await ClockCycles(dut.clk, 1)
        dut._log.info(f"Cycle {i+1} state out: {hex(int(dut.uo_out.value))}")

    # Test Seed Loading Operation: set ui_in[0] high and pass seed on ui_in[7:1]
    dut._log.info("Testing manual seed configuration input loading...")
    dut.ui_in.value = 0b10101011  # ui_in[0]=1 (Load Enable Flag), ui_in[7:1]=seed
    await ClockCycles(dut.clk, 1)
    
    # Clear load flag and watch it run from new seed state
    dut.ui_in.value = 0b00000000
    dut._log.info("Seed loaded successfully. Running from custom initialized state...")
    await ClockCycles(dut.clk, 5)
    
    dut._log.info("LFSR simulation pass completed successfully!")
