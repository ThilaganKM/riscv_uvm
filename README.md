# RV32I 5-Stage Pipelined RISC-V Processor — UVM Verification

> UVM-based functional verification of a custom RV32I 5-stage pipelined RISC-V processor with constrained-random instruction generation, architectural scoreboard, and functional coverage.

**Tools:** QuestaSim 2019 · SystemVerilog · UVM-1.1d · GTKWave  
**Author:** Appalla Subrahmanya Karthikeya

---

## Repository Structure

```
riscv_uvm/
├── rtl/
│   ├── PC.sv                  # Program counter
│   ├── register_file.sv       # 32x32 register file
│   ├── ALU.sv                 # Arithmetic logic unit
│   ├── Alu_decoder.sv         # ALU control decoder
│   ├── forwarding_unit.sv     # EX/MEM and MEM/WB forwarding
│   ├── HazardUnit.sv          # Load-use stall + branch flush
│   ├── main_decoder.sv        # Main control decoder
│   ├── control_unit.sv        # Top-level control
│   ├── data_mem.sv            # Data memory
│   ├── instr_mem.sv           # Instruction memory
│   ├── IF_ID.sv               # Pipeline register: Fetch→Decode
│   ├── ID_IE.sv               # Pipeline register: Decode→Execute
│   ├── IE_IM.sv               # Pipeline register: Execute→Memory
│   ├── IM_IW.sv               # Pipeline register: Memory→Writeback
│   ├── riscv_hazardcontrol.sv # Top-level hazard-controlled pipeline
│   ├── rvhazard_dbg.sv        # Debug wrapper with commit interface
│   └── rvhazard_sva.sv        # SVA protocol assertions
└── tb/
    ├── interfaces/            # Virtual interfaces per unit
    ├── txn/                   # Transaction package
    ├── pipeline/
    │   ├── interfaces/
    │   │   └── pipeline_if.sv         # Pipeline commit interface
    │   ├── pipeline_scoreboard.sv     # Architectural golden reference model
    │   ├── riscv_coverage.sv          # Functional coverage collector
    │   ├── riscv_rand_instr.sv        # Constrained-random instruction generator
    │   ├── pipeline_env.sv            # UVM environment
    │   ├── pipeline_test.sv           # Pipeline test
    │   └── pipeline_pkg.sv            # Package
    ├── tb_pipeline_top.sv     # UVM top module
    └── tb_top.sv              # Block-level TB top
```

---

## Processor Architecture

### 5-Stage Pipeline

```
  ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐
  │  IF  │───►│  ID  │───►│  EX  │───►│ MEM  │───►│  WB  │
  │Fetch │    │Decode│    │Exec  │    │Memory│    │Write │
  └──────┘    └──────┘    └──────┘    └──────┘    └──────┘
                 ▲                        │
                 │    MEM/WB Forward      │
                 └────────────────────────┘
                 ▲              │
                 │  EX/MEM Fwd  │
                 └──────────────┘
```

### Microarchitecture Features

- 32-bit RV32I ISA subset (R-type, I-type ALU, Load, Store, Branch, LUI, JAL)
- 32 general-purpose registers (x0 hardwired to zero)
- Separate instruction and data memory
- EX→EX and MEM→EX forwarding paths (resolves RAW hazards without stalls)
- Load-use hazard detection with 1-cycle pipeline stall insertion
- Branch and jump flush logic (flushes IF/ID on taken branch)
- Sign-extended I/S/B/J/U immediates

### Hazard Handling Summary

| Hazard Type | Resolution | Hardware |
|-------------|-----------|---------|
| RAW (EX→EX) | Forward from EX/MEM register | `forwarding_unit.sv` |
| RAW (MEM→EX) | Forward from MEM/WB register | `forwarding_unit.sv` |
| Load-Use | 1-cycle stall + bubble insert | `HazardUnit.sv` |
| Branch | Flush IF/ID pipeline registers | `HazardUnit.sv` |

---

## Verification Architecture

```
┌──────────────────────────────────────────┐
│              pipeline_env                │
│                                          │
│  ┌───────────────────────────────────┐   │
│  │       pipeline_scoreboard         │   │
│  │  - Architectural register model  │   │
│  │  - Instruction memory mirror     │   │
│  │  - Data memory mirror            │   │
│  │  - Decodes + computes expected   │   │
│  │  - Compares commit_data vs exp   │   │
│  └───────────────────────────────────┘   │
│                                          │
│  ┌───────────────────────────────────┐   │
│  │         riscv_coverage            │   │
│  │  - cg_instr_type                 │   │
│  │  - cg_alu_op                     │   │
│  │  - cg_rd_reg / cg_rs1_reg        │   │
│  │  - cg_hazard                     │   │
│  │  - cg_cross_instr_rd             │   │
│  │  - cg_pc_range                   │   │
│  └───────────────────────────────────┘   │
└──────────────────────────────────────────┘
         │ virtual pipeline_if
         ▼
┌──────────────────────────────────────────┐
│              rvhazard_dbg                │
│         (DUT debug wrapper)              │
│  Exposes: commit_valid, commit_pc,       │
│           commit_rd, commit_data, imem   │
└──────────────────────────────────────────┘
```

### Scoreboard — Golden Reference Model

The scoreboard implements a complete software model of the RISC-V ISA. On every `commit_valid` pulse it:

1. Fetches the instruction from the memory mirror at `commit_pc`
2. Decodes opcode, rd, rs1, rs2, funct3, funct7
3. Computes `expected` result using its own register and memory model
4. Compares `commit_data` against `expected`
5. Updates its register model with the committed result

This means any bug in forwarding, hazard detection, or ALU decoding that causes an incorrect writeback will be caught immediately with a precise error message showing PC, register number, expected value, and actual value.

### Instruction Generation — `riscv_rand_instr`

Constrained-random instruction generator targeting hazard-stress scenarios:

```systemverilog
constraint opcode_c {
  opcode dist {
    7'b0110011 := 40,  // R-type  (ADD/SUB/AND/OR/SLT)
    7'b0010011 := 40,  // I-type  (ADDI/ANDI/ORI/SLTI)
    7'b0000011 := 20   // LOAD    (LW - triggers load-use hazards)
  };
}

constraint dependency_bias {
  if (opcode == 7'b0000011)
    imm_i inside {[0:32]};  // small offsets → frequent load-use scenarios
}
```

200 random instructions loaded into instruction memory, pipeline runs for 1500 cycles.

### SVA Assertions (`rvhazard_sva.sv`)

Protocol-level assertions that fire automatically during simulation to catch hazard unit bugs.

---

## Functional Coverage Results

| Coverage Group | Coverage | Description |
|----------------|----------|-------------|
| Instruction Type | 50.0% | R/I/Load covered (branch/LUI out of constraint scope) |
| ALU Operations | 63.6% | ADD/SUB/AND/OR/SLT/ADDI/LW covered |
| RD Registers | **100.0%** | All 31 writable registers used as destination |
| RS1 Registers | **100.0%** | All 32 registers used as source operand |
| Hazard Coverage | **100.0%** | Load-use and RAW hazard scenarios hit |
| Cross (type × rd) | **100.0%** | All instruction types across all register ranges |
| PC Range | **100.0%** | Instructions spread across full memory range |

**Note on Instruction Type coverage:** The constraint set deliberately focuses on R-type, I-type, and Load instructions to maximize hazard scenario density. Branch and LUI are excluded from the random generator scope. This is an intentional verification decision — hazard unit stress is the primary verification goal.

---

## Simulation Results

```
UVM_ERROR  : 0
UVM_FATAL  : 0
UVM_WARNING: 0

Committed instructions checked : 197
Scoreboard mismatches          : 0
```

Zero functional mismatches across 197 committed instructions under load-stress constrained-random testing.

---

## Bugs Found During Verification

| Bug | Description | How Found |
|-----|-------------|-----------|
| ALU decode mismatch | Incorrect funct7 masking for SUB vs ADD | Scoreboard mismatch at EX stage |
| Memory boundary | Incorrect word-address calculation for load | Load-use stress sequence |
| Forwarding path | MEM→EX forward not triggered for back-to-back loads | Random test with dependency bias |

---

## How to Run

### Prerequisites
- QuestaSim 2019
- UVM-1.1d (included with QuestaSim)

### Commands

```bash
# Block-level unit tests
make compile
make pc        # PC unit test
make rf        # Register file test
make alu       # ALU test
make alu_dec   # ALU decoder test
make fwd       # Forwarding unit test
make haz       # Hazard unit test
make main_dec  # Main decoder test
make ctrl      # Control unit test
make dmem      # Data memory test

# Full pipeline UVM test with coverage
make compile_pipeline
make pipeline

# View coverage report
make coverage_report

# Clean
make clean
```

---

## Tools

- SystemVerilog (IEEE 1800-2012)
- UVM 1.1d
- QuestaSim 2019.2
- Git
