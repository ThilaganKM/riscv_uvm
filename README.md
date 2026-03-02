🚀 RV32I 5-Stage Pipelined RISC-V Verification (UVM)

SystemVerilog | UVM | QuestaSim

📌 Overview

This repository contains verification of a custom RV32I 5-stage pipelined RISC-V processor using a UVM-based testbench.

The processor implements:

IF – Instruction Fetch

ID – Instruction Decode

EX – Execute

MEM – Memory

WB – Write Back

Pipeline hazards (data + control) are fully verified under directed and constrained-random testing.

🏗 Microarchitecture Features

32-bit RV32I ISA

32 general-purpose registers

Separate instruction & data memory

EX/MEM and MEM/WB forwarding

Load-use hazard stall detection

Branch and jump flush logic

Sign-extended I/S/B/J immediates

🧪 Verification Environment

UVM-based testbench

Virtual interface binding

Constrained-random instruction generation

Architectural scoreboard (golden reference model)

Functional coverage collection

SystemVerilog Assertions (SVA)

Load-stress randomized testing

🎯 Verification Achievements

Zero functional mismatches under load-stress randomized tests

Verified RAW hazard scenarios across forwarding paths

Validated load-use stall behavior

Verified branch flush correctness

Achieved full coverage on defined instruction & hazard coverpoints

Resolved ALU decode and memory boundary bugs during stress testing

🛠 Tools

SystemVerilog

UVM 1.1d

QuestaSim

Git
