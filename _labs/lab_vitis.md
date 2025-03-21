---
layout: lab
toc: true
title: Vitis HW/SW HLS Integration
short_title: HW/SW Integration
number: 5
repo: lab_vitis
under_construction: false
---





## Learning Outcomes
The goals of this assignment are to:
* Test your HLS hardware from the last lab, and implement it on an SoC platform.
* Learn how to connect Vitis HLS cores in a larger Vivado hardware project.
* Learn how to call HLS accelerators from software in an SoC environment.
* Gain experience using off-chip memory and streaming interfaces in HLS.

## Preliminary

In this lab you will export your HLS accelerator as an IP to include in a Vivado project on the FPGA.  You will then create an embedded software application in Vitis (different from Vitis HLS), that will communicate with your accelerator.  

Most of the direction for this lab are included in a set of tutorial pages.  Depending on your experience you may need to complete some or all of these tutorials in order to complete this lab:
* [Vivado Tutorial]({% link _pages/vivado_tutorial.md %}): Tutorial on creating a block-design Vivado project with the ARM processor.
* [Vitis Tutorial]({% link _pages/vitis_tutorial.md %}): Running a bare-metal *Hello World* application in Vitis.
* [HLS Integration Tutorial]({% link _pages/hls_integration_tutorial.md %}): Exporting your HLS accelerator as an AXI4 IP and integrating it into your hardware and software projects.

## Implementation

### Part 1: Local Memory
As described in the tutorials, export your HLS IP to RTL, include it in an SoC Vivado project, and write software to run your accelerator (you are provided with most of the code in [main.cpp](https://github.com/byu-cpe/ecen625_student/blob/main/lab_vitis/sw/main.cpp)).  You can use any version of your HLS IP from the last lab (ie, unoptimized, min area, min latency, etc.)

* Take a screenshot of your project in Vivado
* Run your software on the board, and save the output in your report.  Comment on the runtime of your accelerator.  Does it match the latency reported by Vitis HLS? (it should be pretty close)	


In order to minimize the time spent in software, you should disable any printing while timing your code (set `logging` to `false`), and you should set compiler optimizations to *O2* or *O3*.  You can enable compiler optimizations in Vitis by opening your application settings, going to *Compiler Settings->Optimization->Optimization Level*.


### Part 2: Software-Only Runtime
Replace the call to your hardware accelerator with a software implementation of the function.  You should be able to use your existing HLS code with some minor modifications.  Measure and collect the runtime.


### Part 3: Off-chip Memory (Main Memory) 
The way your kNN accelerator is currently configured, the training samples are stored within the accelerator, which means they are implemented using the FPGA fabric, likely using the BRAMs.  This is fast, but it limits the size of the training data that can be used, and requires a lot of FPGA memory resources.

In this part of the assignment you will modify your design to store the training data in main memory (DDR), and pass it to your accelerator as needed.  The [Vitis HLS manual](https://docs.amd.com/r/en-US/ug1399-vitis-hls/Interfaces-of-the-HLS-Design) contains descriptions of how you can alter the interfaces to your IP block.


##### Digitrec Global
* Go to *lab_vitis/hls/digitrec_global* and copy your *digitrec.cpp* implementation.  Inspect *digitrec.h* and note that the traning data is now pass as an *hls::stream*.  Update your code to use *.read()* to get the training data from the stream, rather than accessing it from an array.  **Be careful to fix the array ordering in your code.**  In the provided *digitrec* code, the training data was accessed in this order:
```
  for (int i = 0; i < TRAINING_SIZE; ++i) {
    for (int j = 0; j < 10; j++) {
```
However, this is not how the traning data is laid out in the array.  It did not matter in the previous implementation, because you were accessing it using arbitrary *i* and *j* indexing, but now you will need to access the data in the correct order as it is passed to you in the stream.  The correct order is:
```
  for (int i = 0; i < 10; ++i) {
	for (int j = 0; j < TRAINING_SIZE; j++) {
```
* You are provided a new *digitrec_test.cpp* program that uses the new stream interface.  Run `make c_simulation` to verify that your code still works.

##### MM2S
Next, you will need to create another HLS component (*mm2s*) that will serve as an AXI master, perform memory-mapped reads of the traning data from memory, and send the data over a stream to the *digitrec_global* accelerator.  Go to the *lab_vitis/hls/mm2s*.  
* Implement *mm2s.cpp*.  This should only require a few lines of code to read from the array and send it over the stream.
* Add *pragma HLS INTERFACE* directives to your code to:
	* Assign AXI4-Lite control of the function (as you did in the local memory version).
	* Assign an AXI4-Master interface to the training data memory pointer.  Indicate that the offset in main memory will be provided via the AXI4-Lite interface.
	* Assign an AXI4-Stream interface to the output stream.
* Run `make c_synthesis` and inspect the report to make sure your interfaces are correct.

##### Vivado
Add these two new blocks (*digitrec_global* and *mm2s*) to your Vivado project, and connect everything together.  
  * You will need to enable the *S_AXI_HP0* interface on your ZYNQ7 Processing System, in order to allow the *mm2s* block to access the main memory.  You should add another *AXI SmartConnect* block between the *S_AXI_HP0* and the *mm2s* block.  
  * Assign all addresses in the system.
  * Validate your design and generate a new bitstream and XSA file.

##### Software Runtime
Update your software:
  * After running the local memory version of your accelerator, run the global memory version. 
  * For best performance, you can try using the Auto Restart feature of the *mm2s* block. 

Run you software and collect the runtime.  


## Report and Submission

Make sure your github includes the following:
* A tcl file for your Vivado project that I can run to recreate your project.  This should be in the *hw* directory.
* The C++ source code that you used to run your accelerator and collect runtimes.  This should be in the *sw* directory.

Include a short PDF report, located at `lab_vitis/report.pdf`.  Include the following items:
* Briefly describe your hardware implementation.  What board did you use?  What version of your HLS accelerator did you use?  For example, you may find your largest configuration does not actually fit on the FPGA.  How did you verify that your HLS core was operating correctly?
* **Question:** We could have added the AXI master interface directly to the *digitrec_global* accelerator, rather than creating a separate *mm2s* block.  Why do you think we chose to create a separate block? Hint: 
* Runtimes: provide and compare software-only, local memory, and global memory runtimes.  Comment on the differences.  For the HLS versions, does the per item runtime match the latency reported by Vitis HLS? 
* Screenshot of your final Vivado project.

## Submission 
Submit your code on Github using the tag `lab5_submission`.

