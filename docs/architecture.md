
# RV32I 5-Stage Pipelined RISC-V Architecture

## 1. Overview

This project implements and verifies a 5-stage pipelined RV32I RISC-V processor:

- IF  – Instruction Fetch
- ID  – Instruction Decode
- EX  – Execute
- MEM – Memory
- WB  – Write Back

The design supports arithmetic, logical, branch, load, store, and jump instructions as defined in the RV32I ISA.

---

## 2. Pipeline Stages

### IF (Instruction Fetch)
- Program Counter (PC)
- PC + 4 Adder
- Instruction Memory
- Branch/Jump PC selection

### ID (Instruction Decode)
- Register File
- Immediate Extension Unit
- Main Decoder
- Hazard Detection

### EX (Execute)
- ALU
- ALU Decoder
- Forwarding MUXes
- Branch decision logic

### MEM (Memory)
- Data Memory (32-bit word addressable)
- Store and Load operations

### WB (Write Back)
- Result MUX (ALU / Memory / PC+4)
- Register file write-back

---

## 3. Hazard Handling

### Data Hazards
- EX/MEM forwarding
- MEM/WB forwarding
- Load-use stall detection

### Control Hazards
- Branch resolution in EX stage
- Flush logic on branch taken
- JAL handling

---

## 4. Control Signal Encoding

### ALUOp Encoding

| ALUOp | Meaning |
|-------|---------|
| 00    | ADD (load/store) |
| 01    | SUB (branch) |
| 10    | R-type arithmetic |
| 11    | I-type arithmetic |

### ResultSrc Encoding

| ResultSrc | Source |
|-----------|--------|
| 00        | ALU Result |
| 01        | Memory Read Data |
| 10        | PC + 4 |

---

## 5. Memory Model

- Word-addressable memory
- Address indexing masked to valid range
- Prevents out-of-bound X propagation

---

## 6. Key Debug Learnings

- ALUOp encoding mismatch caused arithmetic inversion
- Forwarding priority errors produced incorrect results
- Memory out-of-bound indexing caused X propagation
- Load-use hazard required precise stall and flush coordination

Final design validated with zero scoreboard mismatches.
