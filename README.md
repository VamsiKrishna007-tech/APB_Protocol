This repository contains a Verilog implementation of an APB (Advanced Peripheral Bus) Master and a corresponding testbench. The APB is a low-power, non-pipelined bus protocol used for connecting low-bandwidth peripherals to the system bus.

## Overview of Design
The apb_master module implements a Finite State Machine (FSM) to handle data transfers between a high-level bus and APB slaves. It supports the standard three-state operation required by the AMBA specification:
IDLE: The default state when no transfer is requested.
SETUP: The state where the peripheral select signal (PSELx) is asserted and the address/control signals are driven.
ACCESS: The state where the enable signal (PENABLE) is asserted to finalize the transfer, waiting for the slave's PREADY signal.

## Port Descriptions
Port      Direction  Width   Description
PCLK      Input        1     Clock signal.
PRESETn   Input        1     Active-low reset signal.
transfer  Input        1     Control signal to initiate a bus cycle.
addr      Input       32     Input address to be driven onto the bus.
wdata     Input       32     Input data to be written to the slave.
write     Input        1     High for Write transfers, Low for Read.
PADDR     Output      32     APB Address Bus.
PWDATA    Output      32     APB Write Data Bus.
PSELx     Output       1     Peripheral Select signal.
PENABLE   Output       1     APB Enable signal.
PWRITE    Output       1     APB Write/Read control signal.
PREADY    Input        1     Ready signal from the slave.

## State Machine Logic
The FSM transitions based on the transfer and PREADY inputs:
IDLE → SETUP: Occurs when transfer is asserted.
SETUP → ACCESS: Automatic transition on the next clock edge.
ACCESS → IDLE/SETUP: If PREADY is high, the FSM returns to IDLE (if transfer is low) or stays in SETUP (if transfer is high) for a back-to-back cycle.

## Verification and Simulation
The provided testbench (apb_slave_tb.v) simulates a basic write transaction:
Reset: The system is initialized with PRESETn low.
Write Cycle: A write request is issued to address 32'hfca_cafe with data 32'hface_cafe.
Wait States: The testbench simulates slave latency by delaying the PREADY signal for 3 clock cycles.
