# Single Cycle MIPS-I Processor Using VHDL

## Project Overview

This project emulates a MIPS-I processor using VHDL on the Nexys A7-100T Trainer board.

Fill in:
- What the processor is designed to do
- What programs are included
- What a user should see when the project is running
- Why this project was chosen

Current notes:
- The project includes a 3D spinning cube displayed through VGA.
- The project includes a Fibonacci sequence visualization displayed through VGA.
- The project was designed for CPE 487 at Stevens Institute of Technology.
- This project was initially inspired by the PlayStation 1 R3000A processor.

## Expected Behavior

Describe the expected behavior of the finished project.

Include:
- What happens when the FPGA is programmed
- What appears on the display
- How the user selects or interacts with the included programs
- What behavior confirms that the processor is working correctly
- Any known limitations or expected edge cases

## Required Hardware and Attachments

List all hardware needed to run the project.

Current hardware:
- Nexys A7-100T Trainer board
- VGA male to HDMI female connector
- VGA cable
- HDMI cable
- Micro USB-B power supply/programming cable

Add if applicable:
- External monitor
- Switches, buttons, LEDs, or seven-segment display usage
- Any other required modules or cables

## System Design

Describe the high-level design of the project.

Include:
- Processor architecture overview
- Major VHDL components/modules
- How instruction memory, control, datapath, registers, ALU, and VGA output connect
- How the included programs are stored and executed
- Any finite state machines, Boolean logic, or control diagrams

Suggested diagrams/images to add:
- High-level block diagram
- Datapath diagram
- Control unit diagram
- VGA output pipeline diagram
- Program flow diagram for the cube or Fibonacci visualization

Image placeholders:

```md
![High-level block diagram](docs/images/block-diagram.png)
![Datapath diagram](docs/images/datapath.png)
```

## Vivado Setup and Build Instructions

Summarize the steps needed to get the project working in Vivado and on the Nexys board.

Fill in:
1. Open Vivado.
2. Create or open the project.
3. Add the required `.vhd` source files.
4. Add the required `.xdc` constraints file.
5. Select the Nexys A7-100T board or correct FPGA part.
6. Run synthesis.
7. Run implementation.
8. Generate the bitstream.
9. Connect the Nexys board.
10. Program the board.
11. Connect the display and confirm output.

Add details for:
- Vivado version used
- Board/part number
- Any project settings that must be changed
- Any memory/program files that must be loaded
- Common setup issues and fixes

## Nexys Board Inputs and Outputs

Describe all inputs from and outputs to the Nexys board.

Inputs:
- Clock:
- Reset:
- Switches:
- Buttons:
- Other inputs:

Outputs:
- VGA red:
- VGA green:
- VGA blue:
- VGA horizontal sync:
- VGA vertical sync:
- LEDs:
- Seven-segment display:
- Other outputs:

Also explain:
- Which ports were added or modified
- How the `.xdc` constraints map VHDL ports to board pins
- How the inputs and outputs demonstrate changes to the VHDL architectures/components

## Project Demonstration

Add images and/or videos of the project in action.

Include:
- Photo of the FPGA setup
- Photo or screenshot of the VGA output
- Video of the spinning cube
- Video or photo of the Fibonacci visualization
- Any debug/test output that helps explain the system

Media placeholders:

```md
![FPGA setup](docs/images/fpga-setup.jpg)
![VGA cube output](docs/images/cube-output.jpg)
![Fibonacci output](docs/images/fibonacci-output.jpg)

[Spinning cube demo](docs/videos/cube-demo.mp4)
[Fibonacci demo](docs/videos/fibonacci-demo.mp4)
```

## Modifications and Original Contributions

Explain what code or project material was created, modified, or reused.

If starter code or lab code was used:
- Name the starter code or lab
- Credit the original creator/source
- Describe what was changed
- Describe what new functionality was added
- Explain why the modifications were important

If the project was created from scratch:
- Summarize the design process
- Explain how the processor was built
- Explain how the VGA programs were created
- Describe the most important implementation decisions

Current note:
- Some AI was used to generate the programs.
- All processor-related code is human-made.

Add required AI citation details:
- What tool was used
- What it was used for
- Which files or sections were affected
- What was reviewed, changed, or written manually afterward

## Code Organization

Describe how the repository is organized.

Fill in the purpose of each major file/folder:

```txt
/
├── README.md
├── src/
│   ├── ...
├── constraints/
│   ├── ...
├── docs/
│   ├── images/
│   └── videos/
└── ...
```

Mention:
- Main top-level VHDL file
- Processor component files
- Program/memory files
- Constraint files
- Testbench files, if any

## Testing and Verification

Describe how the project was tested.

Include:
- Simulation tests performed
- Vivado synthesis/implementation results
- Board testing steps
- How the cube program was verified
- How the Fibonacci program was verified
- Bugs found during testing and how they were fixed

## Team Contributions

Summarize who was responsible for each part of the project.

| Team Member | Contributions |
| --- | --- |
| Name | Processor/datapath/control/etc. |
| Name | VGA/programs/testing/etc. |
| Name | Documentation/Vivado setup/etc. |

Also mention:
- How GitHub was used by the group
- Whether commits reflect individual contributions
- Any shared responsibilities

## Project Timeline

Summarize the timeline of work completed.

| Date/Week | Work Completed |
| --- | --- |
| Week 1 | Project idea and initial design |
| Week 2 | Processor components |
| Week 3 | VGA output |
| Week 4 | Program integration |
| Week 5 | Testing and documentation |

## Difficulties and Solutions

Describe problems encountered and how they were solved.

Include:
- VHDL design issues
- Vivado setup or synthesis issues
- VGA/display issues
- Processor instruction/program issues
- Hardware/debugging issues
- Team coordination issues, if relevant

## Final Summary

Conclude with a short summary of:
- What was accomplished
- What worked successfully
- What could be improved in the future
- What was learned from the project

## Submission Checklist

- [ ] Project behavior is clearly described.
- [ ] Required hardware and attachments are listed.
- [ ] System diagrams/images are included.
- [ ] Vivado setup steps are documented.
- [ ] Nexys board inputs and outputs are described.
- [ ] Images/videos of the project are included.
- [ ] Starter code, modifications, and original contributions are explained.
- [ ] AI usage is cited.
- [ ] Team contributions are listed.
- [ ] Timeline is included.
- [ ] Difficulties and solutions are summarized.
- [ ] Code is organized into appropriate `.vhd` and `.xdc` files.
