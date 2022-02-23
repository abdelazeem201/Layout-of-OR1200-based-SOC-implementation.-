# Layout-of-OR1200-based-SOC-implementation.-
The aim of this project is to design and maintain an OpenRISC 1200 IP Core. OpenRISC 1200 is an implementation of OpenRISC 1000 processor family. The OR1200 is a 32-bit scalar RISC with Harvard microarchitecture, 5 stage integer pipeline, virtual memory support (MMU) and basic DSP capabilities.

<img src= "https://github.com/abdelazeem201/Layout-of-OR1200-based-SOC-implementation.-/blob/main/PICs/OR1200_cpu.png">

# Goals/Objectives

1. Currently, the OR1200 pipeline always assumes a branch is not taken (even for an unconditional jump). If a branch that is taken, there is one delay slot followed by a no-op followed by the instruction branched to. The goal is to remove the no-op.

2. We propose to modify the OR1200 Memory Management Unit (MMU) and synthesize it in a 32nm/28nm technology. Our final goal is to generate the hard IPs for the MMUs of instruction and data cache and integrate it with the caches themselves. Finally we propose to integrate this MMUs in the OR1200 core as a collaborative work. 

<img src= "https://github.com/abdelazeem201/Layout-of-OR1200-based-SOC-implementation.-/blob/main/PICs/TLBOperationOR1200.png">


# Motivation
When executing conditional branch instructions, it is not always known beforehand what the next instruction will be. In a single-cycle processor, this isn't a big issue, as the result of the branch condition is calculated before the next instruction is fetched during the next cycle. However, for a pipeline that has stages before the one where the branch condition is calculated, this isn't possible. In such a case, there are cycles between the fetching of the branch instruction and the calculation of its condition's result. There are several ways to handle this situation. The worst, but simplest, way is to simply stall until the branch's result is calculated. This reduces throughput, however, so a better way would be to predict which instruction to fetch, and if it's not the correct one then flush it. Prediction can be done statically, where the pipeline always predicts the same way, or dynamically, where the pipeline maintains some history of the instruction's result and predicts based off that. In the default OR1200 pipeline, the branch is statically predicted to be not taken. Additionally, the instruction after the branch is always executed regardless of whether the branch is taken or not; this instruction is said to be placed in a delay slot. However, there is another instruction after the delay slot that must be flushed if the branch is taken. Adding a predictor for that instruction would increase throughput of the OR1200 pipeline.

# Method
1. Gain understanding of the datapath of the OR1200 pipeline

2. Synthesize the pipeline without any extra registers

3. Add smarter static branch prediction which assumes not-taken for jumps ahead and taken for jumps behind

4. Add simple 2-bit dynamic branch prediction
