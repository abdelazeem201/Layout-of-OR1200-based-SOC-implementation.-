# Layout-of-OR1200-based-SOC-implementation.-
The aim of this project is to design and maintain an OpenRISC 1200 IP Core. OpenRISC 1200 is an implementation of OpenRISC 1000 processor family. The OR1200 is a 32-bit scalar RISC with Harvard microarchitecture, 5 stage integer pipeline, virtual memory support (MMU) and basic DSP capabilities.

<img src= "https://github.com/abdelazeem201/Layout-of-OR1200-based-SOC-implementation.-/blob/main/PICs/OR1200_cpu.png">

# Goals/Objectives

1. Currently, the OR1200 pipeline always assumes a branch is not taken (even for an unconditional jump). If a branch that is taken, there is one delay slot followed by a no-op followed by the instruction branched to. The goal is to remove the no-op.

2. We propose to modify the OR1200 Memory Management Unit (MMU) and synthesize it in a 32nm/28nm technology. Our final goal is to generate the hard IPs for the MMUs of instruction and data cache and integrate it with the caches themselves. Finally we propose to integrate this MMUs in the OR1200 core as a collaborative work. 

<img src= "https://github.com/abdelazeem201/Layout-of-OR1200-based-SOC-implementation.-/blob/main/PICs/TLBOperationOR1200.png">

3. The goal of this part is to modify (pipeline) the current FPU arithmetic components in the OR1200 CPU so that pipeline stalls due to floating point arithmetic operations shall be reduced as much as possible. The floating point arithmetic functions currently implemented as serial components in OR1200 include: floating point add, sub, multiply, and divide. Other floating point components such as floating point comparison and conversion functions may not be included in this project due to the complexity. It is expected to achieve significant FLOPS improvement compared to current serial implementation.

*Default simplified OR1200 FPU Schematics*

<img src= "https://github.com/abdelazeem201/Layout-of-OR1200-based-SOC-implementation.-/blob/main/PICs/Default%20simplified%20OR1200%20FPU%20Schematics.jpg">

*or1200 fpu arithmetic unit*

<img src= "https://github.com/abdelazeem201/Layout-of-OR1200-based-SOC-implementation.-/blob/main/PICs/or1200%20fpu%20arithmetic%20unit.png">


# Motivation
1. When executing conditional branch instructions, it is not always known beforehand what the next instruction will be. In a single-cycle processor, this isn't a big issue, as the result of the branch condition is calculated before the next instruction is fetched during the next cycle. However, for a pipeline that has stages before the one where the branch condition is calculated, this isn't possible. In such a case, there are cycles between the fetching of the branch instruction and the calculation of its condition's result. There are several ways to handle this situation. The worst, but simplest, way is to simply stall until the branch's result is calculated. This reduces throughput, however, so a better way would be to predict which instruction to fetch, and if it's not the correct one then flush it. Prediction can be done statically, where the pipeline always predicts the same way, or dynamically, where the pipeline maintains some history of the instruction's result and predicts based off that. In the default OR1200 pipeline, the branch is statically predicted to be not taken. Additionally, the instruction after the branch is always executed regardless of whether the branch is taken or not; this instruction is said to be placed in a delay slot. However, there is another instruction after the delay slot that must be flushed if the branch is taken. Adding a predictor for that instruction would increase throughput of the OR1200 pipeline.

2. Memory management unit provides a much bigger virtual address space for the programs to run in modern microprocessors. This virtual address space has an one to one mapping to the physical address space and MMU does the job of mapping it correctly. MMU internally translates the virtual address space to physical address space and usually uses a high speed cache memory called Translate Lookahead Buffer (TLB) to translate it faster. MMUs also provide the feature of memory protection of programs that was impossible without the concept of virtual memory. This ensures that one program's address space does not collide with the another one. In other words a program's access to the virtual memory space is well controlled in sucha way that that program does not write to another programs address space.
2.1.  On the other hand cache memory is fastest available memory that can run at the same speed as the CPU core itself. MMUs provide faster address translation from virtual to physical address space so that effectively read/write cycles are faster in the micro processors.
2.2.  As this class allows us to do a project using Synopsys cad tool, we try to do the full design of the OR1200 micro processor. In this big project our team plans to modify the OR1200 project code to generate the MMU soft-IPs and synthesize it in an actual technology to place and route the physical design of it with the TLBs themselves as hard macros.

3. Floating point unit has wide dynamic range of representable data and easy programming model, providing better precision than fixed point number system. In fact, various applications requires of using floating point unit, and the performance of floating point operations (FLOPS) is one of the major performance measure for a microprocessor. Current FPU on OR1200 CPU is implemented as serial components, therefore for each floating point operation, the pipeline inevitably stalls and wait for the floating point operation to be finished. According to the OR1200 specifications, the stall could take up to 38 clock cycles for floating point division operations. This result in very poor floating point operation performance and may significantly limit the potential application domain for OR1200 CPU. By implementing a pipelined FPU and integrate with the current integer pipeline, the floating point performance could be significantly improved. The OR1200 CPU will no longer be limited mostly to integer applications.


# Method
*For or1200 CPU*
1. Gain understanding of the datapath of the OR1200 pipeline

2. Synthesize the pipeline without any extra registers

3. Add smarter static branch prediction which assumes not-taken for jumps ahead and taken for jumps behind

4. Add simple 2-bit dynamic branch prediction

*For Fully Pipelined FPU for OR1200 CPU*

1. Analyze existing arithmetic unit implementation in the OR1200 FPU: 
 
   a. Identify the components that are implemented as combinational blocks, which requires pipeline stalls. 
 
   b. Explore alternative implementations for replacing the serial component.

2. Pipeline the FPU arithmetic unit. 
 
   a. Replace the serial implementation with existing pipelined components or perform register retiming using Synopsys retiming tool
 
   b. Reducing pipeline stages as much as possible without hurting the performance 

3. Apply top-down design flow:
  
    a. Use design compiler to perform synthesis 
  
    b. Modify current synthesis flow script to allow for register retiming 
  
    c. Synthesis pipelined components separately, and use a black-box flow for the top level FPU synthesis
  
    d. Remove black-box before IC layout, and add in synthesized pipelined components 
  
    e. Use IC compiler to layout the pipelined OR1200 FPU

4. Power, area, and performance measurement using design compiler and IC compiler 
