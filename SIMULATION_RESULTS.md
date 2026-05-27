# VSDBabySoC Pre-Synthesis Simulation Results

## Date: May 25, 2026

## What was fixed from original repo
1. **Testbench timing bug** — Original testbench enabled PLL AFTER asserting reset.
   CLK was X (unknown) during CPU startup, so CPU never executed.
   Fix: Enable PLL first, wait 900ns for clock stabilization, then assert reset.

2. **Missing source files** — Makefile used Docker (removed). 
   Compiled all modules explicitly with iverilog.

3. **VCD path** — Fixed dumpfile path from post_synth to pre_synth.

## Simulation Command
```bash
iverilog -o output/pre_synth_sim/pre_synth_sim.out \
  -DPRE_SYNTH_SIM \
  src/module/testbench.v \
  src/module/vsdbabysoc.v \
  src/module/rvmyth.v \
  src/module/avsdpll.v \
  src/module/avsddac.v \
  src/module/clk_gate.v \
  -I src/include -I src/module
cd output/pre_synth_sim && ./pre_synth_sim.out
gtkwave pre_synth_sim.vcd
```

## Results
| Signal | Expected | Observed | Status |
|--------|----------|----------|--------|
| CLK | Toggling ~40MHz | Toggling | ✅ |
| reset | High then low | Correct pulse | ✅ |
| RV_TO_DAC[9:0] | 0→43→0 triangle | Triangular staircase | ✅ |
| OUT (DAC) | Analog triangle wave | 0V→0.138V→0V | ✅ |

## Waveform
![Pre-synthesis simulation](docs/screenshots/pre_synth_sim_waveform.png)

## What this proves
- RVMYTH CPU executes the sine-approximation program correctly
- PLL generates stable clock from 12MHz reference
- 10-bit DAC correctly converts digital staircase to analog voltage
- Full SoC integration working at behavioral level
