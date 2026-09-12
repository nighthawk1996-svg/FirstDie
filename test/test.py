# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # 7-segment decoder pin mapping: ui_in[3:0] = hex digit, ui_in[4] = dp passthrough
    SEGMENTS = [
        0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07,
        0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71,
    ]

    async def check(digit, dp):
        dut.ui_in.value = (dp << 4) | digit
        await ClockCycles(dut.clk, 1)
        expected = (dp << 7) | SEGMENTS[digit]
        assert dut.uo_out.value == expected, (
            f"digit={digit} dp={dp}: expected {expected:#04x}, got {int(dut.uo_out.value):#04x}"
        )

    for digit in range(16):
        await check(digit, dp=0)
    await check(digit=5, dp=1)
