This repository contains a Verilog implementation of an APB (Advanced Peripheral Bus) Master and a corresponding testbench. The APB is a low-power, non-pipelined bus protocol used for connecting low-bandwidth peripherals to the system bus.

## Overview of Design
The apb_master module implements a Finite State Machine (FSM) to handle data transfers between a high-level bus and APB slaves. It supports the standard three-state operation required by the AMBA specification:
IDLE: The default state when no transfer is requested.
SETUP: The state where the peripheral select signal (PSELx) is asserted and the address/control signals are driven.
ACCESS: The state where the enable signal (PENABLE) is asserted to finalize the transfer, waiting for the slave's PREADY signal.

## Port Descriptions
<img width="728" height="493" alt="image" src="https://github.com/user-attachments/assets/3bb73c61-12d0-4d45-946d-a319c567b11f" />

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
