# UVM Verification of the AMBA APB Protocol

This repository contains a complete UVM (Universal Verification Methodology) environment for the AMBA APB (Advanced Peripheral Bus) protocol. The verification effort is split into two independent, self-checking testbenches — **Master** and **Slave** — each built around a class-based UVM architecture with dedicated agents, drivers, monitors, scoreboards, and functional coverage models.

The goal of this project is to demonstrate a realistic, industry-style verification flow: constrained-random stimulus generation, protocol-accurate driving/monitoring, automated checking via scoreboards, and closure of functional coverage as the sign-off metric.

---

## Repository Structure

```
├── Master/   # UVM testbench for the APB Master controller (apb_master.v)
└── Slave/    # UVM testbench for the APB Slave register file (apb_regfile.v)
```

---

## 1. APB Master Verification (`/Master`)

The APB Master testbench verifies the master controller's ability to correctly initiate APB transactions, drive address/control signals per protocol timing, and properly react to slave responses — including wait states (`PREADY`) and error responses (`PSLVERR`).

### Verification Environment
The UVM environment (`mstr_env`) instantiates an agent (driver, monitor, sequencer), a reference-model-based scoreboard, and a functional coverage subscriber (`mstr_sub`) that samples the APB interface every clock cycle.

### Test Sequences
The top-level test (`mstr_test`) runs the following sequences to stress the design:

*   **`mstr_reset_seq`** — Verifies correct behavior during and immediately after system reset.
*   **`mstr_write_seq`** — Drives constrained-random single write transactions to the slave.
*   **`mstr_read_seq`** — Initiates constrained-random single read transactions from the slave.
*   **`mstr_write_read_seq`** — Alternates writes and reads to check data integrity and correct FSM state transitions.
*   **`mstr_write_read_btb_seq`** — Drives back-to-back (BTB) write and read transactions with no idle cycles, targeting pipelining efficiency and edge-case handling.

### Functional Coverage
Functional coverage is collected via the `master_cg` covergroup in `mstr_sub.sv`, sampling the master's address, control, and data channels. The covergroup tracks **13 coverpoints** (including `paddr_cp`, `pwrite_cp`, `psel1_cp`, `psel2_cp`, `penable_cp`, `pwdata_cp`, `prdata_cp`, `pslverr_cp`, `pstrb_cp`, `en_cp`, `sel_cp`, `wdata_cp`, `dataout_cp`) and **7 cross-coverage bins** capturing interactions between address regions, transaction type, and error responses.

| Metric | Result |
|---|---|
| Covergroup Coverage | **100.00%** |
| Coverpoints/Crosses | 20 (13 coverpoints + 7 crosses) |
| Total Bins Covered | 225 / 225 |

---

## 2. APB Slave Verification (`/Slave`)

The APB Slave testbench targets a peripheral APB register file, verifying correct handling of read/write accesses, wait-state insertion, and slave-error (`PSLVERR`) generation on invalid address accesses.

### Verification Environment
The UVM environment (`slave_env`) drives the APB interface as a bus master toward the DUT and monitors the slave's responses, with a scoreboard cross-checking register contents and a functional coverage subscriber (`slave_sub`) sampling the interface.

### Test Sequences
The top-level test (`slave_test`) runs the following sequences to validate the slave's functionality:

*   **`slave_reset_seq`** — Asserts reset and verifies all internal registers return to their default values.
*   **`slave_write_seq`** — Writes data to the slave's internal registers (Data, Control, Config).
*   **`slave_read_seq`** — Reads back register contents to confirm write correctness and verify read-only registers (e.g., Status register).
*   **`slave_write_read_seq`** — Combines writes and reads to verify standard operational flows and ensure no data corruption.

### Functional Coverage
Functional coverage is collected via the `slave_cg` covergroup in `slave_sub.sv`. The covergroup tracks **6 coverpoints** (`paddr_cp`, `pwrite_cp`, `pwdata_cp`, `prdata_cp`, `pslverr_cp`, `pstrb_cp`) and **5 cross-coverage bins**, targeting each internal register (Data, Control, Config, Status) crossed with read/write direction and error responses.

| Metric | Result |
|---|---|
| Covergroup Coverage | **100.00%** |
| Coverpoints/Crosses | 11 (6 coverpoints + 5 crosses) |
| Total Bins Covered | 180 / 180 |

---

## Running the Tests

Both testbenches include `run.do` scripts for simulation in an EDA tool (e.g., QuestaSim/ModelSim) and follow the standard UVM build/connect/run phasing flow. To run a testbench:

```tcl
vsim -do run.do
```

Coverage reports are generated automatically at the end of the run and can be viewed in the tool's coverage viewer or as a text report (`mstr_cvg.txt` / `slave_cvg.txt`).
