# FPGA Stopwatch with Split-Time Memory & Custom Arithmetic

![Language](https://img.shields.io/badge/Language-Verilog-blue)
![Platform](https://img.shields.io/badge/Platform-Xilinx_Artix--7-green)
![Tool](https://img.shields.io/badge/Tool-Vivado-orange)

## 📌 Project Overview
This project is a high-precision digital stopwatch implemented on the **Xilinx Artix-7 FPGA (Basys 3)**.

Unlike standard counter implementations, this design focuses on high-performance VLSI architectures. It features a custom Conditional Sum Adder (CSA) for timing optimization, a Circular Buffer (Stash) for split-time recording, and a robust Debouncer for signal integrity.

The design was synthesized and implemented with 0 timing violations and a positive slack of 3.533 ns at 100 MHz.

## ⚙️ Key Features
* **Precision Timing:** 0.01s resolution (MM:SS:ms format).
* **Split-Time Memory ("Stash"):** A circular buffer FIFO that records timestamps without pausing the main timer. Includes a combinational bypass path for immediate read-out visibility.
* **Architecture-Aware Arithmetic:** Replaced standard ripple-carry adders with CSAs to reduce carry-propagation delay from $O(N)$ to $O(\log N)$.
* **Limited Incrementor:** Parameterized modulo-operator used for efficient frequency division (100MHz $\to$ 1Hz).
* **Signal Integrity:** Inputs are filtered using a Saturated Counter Debouncer (Hysteresis), modeling a digital Low-Pass Filter to reject mechanical switch noise.
* **Control:** A 3-state Moore FSM (IDLE, COUNTING, PAUSED) separating control logic from the datapath.

## 🔧 System Architecture

### Top Level Block Diagram
<img width="457" height="627" alt="image" src="https://github.com/user-attachments/assets/e91b32e7-a97e-4c8e-ae3f-3da205c2a26e" />

The design is modular, separating the Control Plane from the Data Plane:

| Module | Function | VLSI Concept Applied |
| :--- | :--- | :--- |
| **CSA** | 32-bit Adder | Carry-Select Optimization / Timing Closure |
| **Lim_Inc** | Timer Core | Modular Arithmetic / Cascaded Logic |
| **Stash** | Split Memory | Circular Buffer / Memory Pointers |
| **Ctl** | FSM | State Machine / Control-Data Separation |
| **Debouncer** | Input Filter | Digital Signal Processing / Hysteresis |

### The Conditional Sum Adder (CSA)
To meet tight timing constraints, a CSA structure was used. By pre-calculating sums for both carry-in scenarios ($C_{in}=0$ and $C_{in}=1$) and multiplexing the result, the critical path was significantly reduced compared to a ripple-carry architecture.

CSA Waveform: <img width="1114" height="448" alt="image" src="https://github.com/user-attachments/assets/993037ef-e6fb-4413-b334-0ae2d3dd04cd" />

*Simulation verifying the Conditional Sum Logic operating correctly.*

## 📊 Performance & Synthesis Results

### Timing Analysis
* **Target Clock:** 100 MHz (10.00 ns period)
* **Worst Negative Slack (WNS):** `+3.533 ns` 
* **Critical Path Delay:** `6.505 ns`
* **Theoretical Max Frequency:** `~154 MHz`

**Timing Summary:**
<img width="1137" height="275" alt="image" src="https://github.com/user-attachments/assets/c3ae6faf-90ca-4031-9449-22c334604346" />


### Resource Utilization
The design is highly efficient, leaving significant room on the FPGA for additional logic.
* **LUT Utilization:** ~1%
* **Power Consumption:** 0.098 W (Total On-Chip Power)

## 📸 Verification
The design was verified using self-checking testbenches for every module.

**Controller FSM Verification:**
<img width="1135" height="578" alt="image" src="https://github.com/user-attachments/assets/42a8bac0-4b7d-4bd4-bb14-c8fe2ca3ad2f" />

*Waveform demonstrating the transition between IDLE, COUNTING, and PAUSED states.*

---
*University Project | Tel Aviv University | Electronics Lab B*
