# Single Cycle MIPS-I Processor Using VHDL

## Project Overview

This project emulates a MIPS-I processor using VHDL on the Nexys A7-100T Trainer board.
The processor was designed to be a general purpose processor, capable of graphics rendering, instruction handling, memory handling, and a lot more. We programmed a file manager, a 3d spinning cube, and the Fibonacci Sequence visualization displayed through VGA all on the board. This project was originally a PlayStation 1 emulator which uses an R3000A chip that we modelled our processor by. The R3000A is a 32 bit, pipelined processor that uses the MIPS-I ISA. It features no level 1 cache and instead uses instruction cache and an on-chip cache controller. 

## Expected Behavior
When the FPGA is on and connected to a display through VGA, the 3D spinning cube should display on the screen. A register increments the phase angle of the cube and other registers are designated for geometry calculations using MUL and ADDI instructions. The file manager uses the on-board buttons to toggle it on and move between our two programs. While the file manager is open, there will be a menu on the bottom of all 32 registers and their values. Once manuevered over to the Fibbonacci Sequence program, you will see many squares and sections flashing colors.

### WARNING: The Fibonacci Sequence Visualizer shows bright flashing lights that may trigger discomfort or seizures. 

## Required Hardware and Attachments

- Nexys A7-100T Trainer board including the on-board buttons
  ![](https://cdn11.bigcommerce.com/s-7gavg/images/stencil/1280x1280/products/629/5235/NexysA7-obl-600__85101.1670975737.jpg?c=2 "Nexys A7 board. Image from Digilent")

- VGA male to HDMI female connector
  ![](https://ventiontech.com/cdn/shop/files/800x800_e25452ea-7b1d-4002-8ea5-6bf40a257c05.jpg?v=1741227776&width=600 "VGA male to HDMI female connector. Image from Vention")
  
- VGA cable
  ![](https://upload.wikimedia.org/wikipedia/commons/8/81/Vga-cable.jpg "VGA Cable")
  
- HDMI cable
  ![](https://upload.wikimedia.org/wikipedia/commons/c/c2/HDMI-Connector.jpg "HDMI Cable")
  
- Micro USB-B power supply/programming cable
  ![](https://upload.wikimedia.org/wikipedia/commons/d/db/MicroB_USB_Plug.jpg "Micro USB-B cable")
  
- External monitor
  ![](https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/MonitorLCDlcd.svg/1920px-MonitorLCDlcd.svg.png "Monitor")
  
## System Design

Include:
![](./images/mips.png "D. Harris and S. Harris, Digital Design and Computer Architecture, 2nd ed. Waltham, MA, USA: Morgan Kaufmann, 2012. Figure 7.11") 

Our procesor is modelled off this single-cycle diagram. Each area highlighted is roughly what group of components it corresponds to. 

![Video of our Cube spinning. Path: ./images/RenderedVideo.mov](./images/RenderedVideo.mov)

This is a video of our Cube program. It uses sine and cosine approximations to find the vertices. 

![Video of our Fibonacci Sequence Visualizer. Path:./images/80023541081__381BFAF5-C00E-43DB-99CE-1197B2DE273A.mov ](./images/80023541081__381BFAF5-C00E-43DB-99CE-1197B2DE273A.mov)
<iframe width="560" height="315" src="https://www.youtube.com/shorts/embed/fr5oQ23pl1U" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

This is a video of our Fibonacci Sequence Visualizer. It feeds Fibonacci sequence numbers into pixel data and it showcases the output. We slowed the clock down so it can be seen easier.

![](./images/FSM.png)

This is the FSM on how our file manager works. It starts by waiting for the Left button to be toggled. If it toggles, then it opens the menu. While it's toggled then you can move between programs using the up and down buttons on the board. Press the toggle button again to close the file manager. 

## Vivado Setup and Build Instructions
1. Open Vivado.
2. Create or open the project.
3. Add the `.vhd` source files found in the sources_1 folder.
4. Add the `.xdc` constraints file found in the constrs_1.
5. Select the Nexys A7-100T board. 
6. Run synthesis.
7. Run implementation.
8. Generate the bitstream.
9. Connect the Nexys board.
10. Program the board.
11. Connect the display and confirm output.

## Nexys Board Inputs and Outputs
Inputs:

- Clock: Two clocks in the system, one for the PC to know when to refresh and another for the VGA drivers.
- Reset: Multiple resets in the system to ensure that we can reset the board without having to flash the board again.
- Instr: Machine code stored in instruction memory. 
- Buttons: We use the on-board buttons to navigate between the different programs. 

Outputs:

- VGA red: 3 bit vector that tell the VGA cable to display red and they control the vibrancy of the color.
- VGA green: 3 bit vector that tell the VGA cable to display green and they control the vibrancy of the color.
- VGA blue: 2 bit vector that tell the VGA cable to display blue and they control the vibrancy of the color.
- VGA horizontal sync: VGA works similar to a CRT monitor and has sync times between writing the pixels row by row. 
- VGA vertical sync: VGA has dedicated sync times on when to move to a different column.
- 
There are hundreds of inputs and outputs in this system that work as both. Looking through `FPGAtop.vhd` or `MIPSmicroprocessor.vhd` will give a good idea of how signals interact across components.

```vhdl
p: pc
port map(
    clk   => clk,
    reset => rst,
    din   => pc_next,
    dout  => programc
);

i: instructionmemory
port map(
    addr           => programc,
    program_select => program_select,
    instr          => instr
);
```
## Modifications and Original Contributions

Our original process was to create a PlayStation 1 emulator on the FPGA. The PlayStation 1 uses the R3000A as its main processor which simplified a lot of the choices we needed to make. It is a 32-bit pipelined processor that uses the MIPS-I ISA. We chose to make a 32 bit single-cycled processor that also uses the MIPS-I ISA. If time would have allowed, we would have created a pipelined processor instead but after implementing a fully working single cycle CPU, we realized that we had nowhere near enough time for a project this ambitious. We still wanted to showcase what our processor can do and how well it can handle what we throw at it. We chose to showcase this process through graphics handling. The Cube program uses a phase counter in $6. Each cycle it computes a triangle-wave approximation of sine and cosine into $8 and $9. Through the ALU, it can project the 3D coordinates on a 2D plane. The Fibonacci Sequence Visualizer stores the different numbers in $1-10 and feeds those into display generator for the VGA cable to convert into pixel data. 

One of the most important implementation decisions was to move from a word-based program counter to an instruction-based counter. They accomplish the same thing but instead of adding 4 to PC to start a new instruction, we just increment by 1. This also makes some of the branching math a lot easier and uses less shifts and resources on the program counter. Another decision was combining our control path and our decoder into one component. It allows us to send our signals and decode the instruction easier than making them separate components. Another decision we made was keeping a single-cycle processor instead of going to multi-cycle or pipelined. 

A decision we chose to save time with was using AI to code our programs. AI was used sparcely on our actual processor and all code is created by us. When it came time to show what our processor can do with programs, it made the most semse for us to use AI to push our processor to its fullest limit, which it does. Almost all of the on-board memory was taken up by picture data, until we optimized the Cube to use machine code instead and it is a call back to the graphics rendering we wished to see from our PS1 emulator. A lot of the logic gates are being used every clock cycle, more than we had seen on any lab for the class. The AI used is a mix between Gemini and ChatGPT for the programs generated. Ethically and educationally, we see no issue in AI being used for the programs as the goal of this project was to make a functional general purpose CPU. AI allows us to showcase our project in its full without having to stress about doing a separate project within our project. 

Also, `VGA_Sync.vhd` and `VGA_top.vhd` are originally from [Lab 3](https://github.com/byett/dsd/tree/CPE487-Spring2026/Nexys-A7/Lab-3). They were copied and pasted in full and were barely changed over the course of this project. 

## Code Organization

```txt
/
├── README.md
├── sources_1/
|  ├── FPGA_top.vhd
|  ├── MIPSmicroprocessor.vhd
|  ├── alu.vhd
|  ├── clk_wiz_0.vhd
|  ├── clk_wiz_0_clk_wiz.vhd
|  ├── controlunit.vhd
|  ├── counter.vhd
|  ├── data_memory.vhd
|  ├── display_generator.vhd
|  ├── instructionfetch.vhd
|  |  ├── instructionmemory.vhd
|  |  └── pc.vhd
|  ├── leddec.vhd
|  ├── mux.vhd
|  ├── regfile.vhd
|  ├── signext.vhd
|  ├── vga_sync.vhd
|  └── vga_top.vhd
├── constraints/
│   ├── leddec.xdc
├── mips.png
├── FSM.png
└── ...
```

Our processor imports almost everything into the top two modules, `FPGA_top.VHD` and `MIPSmicroprocessor.VHD` except for our instruction fetch top module. That has instruction memory and our PC ported in. Altogether it moves the instructions around so our CPU can perform the correct instructions in the correct order. `VGA_sync.vhd` and `VGA_top.vhd` handle the driver and communication between the board and the VGA cable. `Display_generator.VHD` takes data from our registers and manages it to feed to the VGA drivers. All CPU components are explained in the System Design section above. 

## Testing and Verification

We had issues making a testbench that accurately showed the values of the register and instructions being performed. It wasn't until we started testing on the physical board that we began fixing these problems. We could have done a better job organizing the project in hindsight but overall, we did not have many issues with this project. We initially started with visualizing our registers on the board, once we saw the register values changing we knew that meant our CPU could perform some instructions. Feeding it more instructions and giving it other instructions is how we continued to improve and test if they worked. We know our programs work because they visualize what we expect and there is no real testing or debugging needed. 

## Team Contributions

Summarize who was responsible for each part of the project.

| Team Member | Contributions |
| --- | --- |
| Jason | ALU, Memory, File Manager, Fibonacci Sequence, Display Generator, Constraints|
| Michael | Control Unit, Registers, Decoder, Cube, Display Generator, Fibonacci Sequence, Poster |
| Julian | Instruction Fetch, Instruction Memory, Documentation, Troubleshooting, PC, Documentation |

Github was not really used until after the processor was complete. The commits reflect the individual contribution of work done after the processor but a lot of the work prior was worked on together in class. The CPU component contributions reflect the responsibility of who contributed the most. 

## Project Timeline

Summarize the timeline of work completed.

| Date/Week | Work Completed |
| --- | --- |
| Week 1 | Project idea and initial design |
| Week 2 | Processor components |
| Week 3 | Processor components and debugging |
| Week 4 | VGA display |
| Week 5 | Testing and documentation |

## Difficulties and Solutions
We had issues on figuring out how much time it would take us for a PS1 emulator which resulted in us simplifying the project. We had issues making a testbench that accurately showed the values of the register and instructions being performed. It wasn't until we started testing on the physical board that we began fixing these problems. We could have done a better job organizing the project in hindsight but overall, we did not have many issues with this project. 

## Final Summary

In conclusion, we created a general purpose single-cycle processor that was able to open different programs and display 3D rendered graphics. Some future improvements on this project could be transitioning it from single-cycle to pipelined, adding memory, adding I/O support, optimizing display_generator.vhd to use a framebuffer in data memory, optimizing the display to showcase tiles, and more. We learned a lot about how computers function, specifically a lot more in the memory, graphics, and display areas. This project was very valuable and I hope future students add onto it and hopefully finish our goal of creating a PS1 emulator. 

