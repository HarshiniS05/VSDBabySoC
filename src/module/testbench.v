`timescale 1ns / 1ps

module vsdbabysoc_tb;

    // Input regs
    reg reset;
    reg VCO_IN;
    reg ENb_CP;
    reg ENb_VCO;
    reg REF;
    reg real VREFH;

    // Output wire
    wire real OUT;

    // Instantiate the DUT (choose module based on POST_SYNTH_SIM)
`ifdef POST_SYNTH_SIM
    vsdbabysoc uut (
        .OUT(OUT),
        .reset(reset),
        .VCO_IN(VCO_IN),
        .ENb_CP(ENb_CP),
        .ENb_VCO(ENb_VCO),
        .REF(REF),
        .VREFH(VREFH)
    );
`else
    vsdbabysoc uut (
        .OUT(OUT),
        .reset(reset),
        .VCO_IN(VCO_IN),
        .ENb_CP(ENb_CP),
        .ENb_VCO(ENb_VCO),
        .REF(REF),
        .VREFH(VREFH)
    );
`endif

    // Stimulus
    initial begin
    reset = 0;
    VREFH = 3.3;
    ENb_CP = 0;
    ENb_VCO = 0;
    REF = 0;
    VCO_IN = 0;
    // Enable PLL first — let clock stabilize before reset
    #10  ENb_CP  = 1;
    #10  ENb_VCO = 1;
    // Wait for PLL clock to stabilize
    #900 reset = 1;
    #100 reset = 0;
    end

    // Clock generation for REF and VCO_IN
    initial begin
        repeat(600) begin
            #100 REF = ~REF;              // REF toggling
            #(83.33/2) VCO_IN = ~VCO_IN;  // VCO_IN toggling
        end
    end

    // VCD dump
    initial begin
        $dumpfile("pre_synth_sim.vcd");
        $dumpvars(0, vsdbabysoc_tb);
    end

    // Finish simulation after certain time
    initial begin
        #20000000;
        $finish;
    end

endmodule

