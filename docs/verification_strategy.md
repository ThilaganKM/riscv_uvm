# Verification Strategy

## 1. Testbench Architecture

The processor is verified using a UVM-based environment:

- Driver
- Monitor
- Virtual interface binding
- Architectural scoreboard
- Constrained-random instruction generation
- Functional coverage collection
- SystemVerilog Assertions (SVA)

---

## 2. Scoreboard

The scoreboard maintains a golden architectural model:

- Tracks register state
- Computes expected results
- Compares against commit interface
- Reports mismatches

Zero mismatches achieved under stress testing.

---

## 3. Hazard Verification Matrix

| Scenario | Verified | Method |
|----------|----------|--------|
| EX→EX RAW Forwarding | Yes | Random |
| MEM→EX RAW Forwarding | Yes | Directed |
| Load-Use Hazard | Yes | Stress |
| Branch Taken | Yes | Directed |
| Branch Not Taken | Yes | Random |
| JAL | Yes | Directed |

---

## 4. Assertions

SystemVerilog Assertions added to verify:

- Forwarding priority correctness
- Load-use stall correctness
- No write to x0
- Flush behavior on branch

---

## 5. Randomized Stress Testing

Random instruction streams generated to stress:

- Back-to-back hazards
- Load forwarding cases
- Branch flush overlap
- Mixed arithmetic + memory sequences

All tests completed with zero functional mismatches.

---

## 6. Debug Timeline

Major issues resolved during development:

1. ALUOp encoding mismatch between main_decoder and ALU decoder
2. Incorrect forwarding source selection for load instructions
3. Memory boundary X propagation
4. Pipeline flush misalignment

Final validation result: Stable pipeline under constrained-random load stress.
