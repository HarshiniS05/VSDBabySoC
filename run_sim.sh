#!/bin/bash
mkdir -p output/pre_synth_sim
iverilog -o output/pre_synth_sim/pre_synth_sim.out \
  -DPRE_SYNTH_SIM \
  src/module/testbench.v \
  src/module/vsdbabysoc.v \
  src/module/rvmyth.v \
  src/module/avsdpll.v \
  src/module/avsddac.v \
  src/module/clk_gate.v \
  -I src/include \
  -I src/module
cd output/pre_synth_sim && ./pre_synth_sim.out
echo "Done. Run: gtkwave output/pre_synth_sim/pre_synth_sim.vcd"
