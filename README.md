# Single Cycle MIPS-I processor using VHDL
This project emulates an MIPS-I processor using VHDL on the Nexys A7-100T Trainer board. The project is a general purpose processor that has two programs installed. 
A 3D spinning cube that is built through the instructions and displayed through VGA and the fibonacci sequence visualized through VGA. 

This project was designed for CPE 487 at Stevens Institute of Technology and is no longer being updated.
Some AI was used to generate the programs but all processor-related code is human-made.

### Tools used
-FPGA: Nexys A7-100T Trainer board
-Display: VGA Male to HDMI Female connector, VGA Cable, HDMI cable, Micro USB-B power supply

### Processor
This project was initially to emulate a PS1 which uses an R3000A chip. 

## Submission (80% of your project grade):
* Your final submission should be a github repository of very similar format to the labs themselves with an opening README document with the expected components as follows:
	* A description of the expected behavior of the project, attachments needed (speaker module, VGA connector, etc.), related images/diagrams, etc. (10 points of the Submission category)
		* The more detailed the better – you all know how much I love a good finite state machine and Boolean logic, so those could be some good ideas if appropriate for your system. If not, some kind of high level block diagram showing how different parts of your program connect together and/or showing how what you have created might fit into a more complete system could be appropriate instead.
	* A summary of the steps to get the project to work in Vivado and on the Nexys board (5 points of the Submission category)
 	* Description of inputs from and outputs to the Nexys board from the Vivado project (10 points of the Submission category)
  		* As part of this category, if using starter code of some kind (discussed below), you should add at least one input and at least one output appropriate to your project to demonstrate your understanding of modifying the ports of your various architectures and components in VHDL as well as the separate .xdc constraints file.
	* Images and/or videos of the project in action interspersed throughout to provide context (10 points of the Submission category)
	* “Modifications” (15 points of the Submission category)
		* If building on an existing lab or expansive starter code of some kind, describe your “modifications” – the changes made to that starter code to improve the code, create entirely new functionalities, etc. Unless you were starting from one of the labs, please share any starter code used as well, including crediting the creator(s) of any code used. It is perfectly ok to start with a lab or other code you find as a baseline, but you will be judged on your contributions on top of that pre-existing code!
		* If you truly created your code/project from scratch, summarize that process here in place of the above.
	* Conclude with a summary of the process itself – who was responsible for what components (preferably also shown by each person contributing to the github repository!), the timeline of work completed, any difficulties encountered and how they were solved, etc. (10 points of the Submission category)
* And of course, the code itself separated into appropriate .vhd and .xdc files. (50 points of the Submission category; based on the code working, code complexity, quantity/quality of modifications, etc.)
* You are not really expected to be github experts – as long as one of you can confidently create the repository and help others add to it, that should be sufficient. If no group members fall under this criteria, discuss with me as soon as possible.
	* This is a group assignment, and for the most part you are graded as a group. I reserve the right to modify single student grades for extenuating circumstances, such as a clear lack of participation from a group member. You are allowed to rely on the expertise of your group members in certain aspects of the project, but you should all have at least a cursory understanding of all aspects of your project.
 * One additional note: You MAY use genAI or similar tools to assist with formatting your github repo, to create starter code that you then further modify to meet your final project objectives, or to assist you for troubleshooting or similar tasks. You MUST cite any occurrences of you doing so. You MAY NOT use genAI to do your project for you, or to completely write your repo's content for you. GenAI does not know what you actually did for your project - only you do!
