---
layout: page
toc: false
title: Vivado Tutorial
---

### Previous: [Installing Vitis/Vivado]({% link _pages/install_vitis.md %})

## Setup

### Installing Boards
If you are using a Digilent board, such as the PYNQ Z-2, you need to setup the board files in Vivado.  See <https://github.com/Xilinx/XilinxBoardStore>.  For example, to install the files for the PYNQ-Z2 board, you would run:
```
xhub::refresh_catalog [xhub::get_xstores xilinx_board_store]
xhub::install [xhub::get_xitems *pynq*]
```

### Running Vivado
```
/tools/Xilinx/Vivado/2024.2/bin/vivado
```

After launching Vivado, open the Tcl console and run the following to make sure you can access the installed boards from the last step:
```
set_param board.repoPaths [get_property LOCAL_ROOT_DIR [xhub::get_xstores xilinx_board_store]]
```

## Creating a Simple Hardware Project

### Creating the Project
After launching Vivado, follow these steps to create a hardware project:
1. _Create Project_..., and choose a project name and location.  You can name your project whatever you want, but make sure you place the project in it's own directory.  For example, my project was named *625_lab5* and located at *lab_vitis/hw/625_lab5*. (Note that I chose to add a _hw_ subdirectory and then created a project directory within this.  You will see why this is useful when you get to the section on _Committing to Git_). Click Next.  Choose an RTL project. Click _Next_.  
2. You don't need to add any sources or constraints yet, just click _Next_.
2. On the next you will be asked to choose an FPGA part.  Click _Boards_ at the top, and choose your board (ie. Tul PYNQ).  Click Finish to create your project.

### Creating a Base Design
In these steps we will create a basic system, containing only the Zynq processing system (PS).
1. Click _Create Block Design_, and click _OK_ on the popup.
1. Add the _ZYNQ7 Processing System_ IP to the design (right-click, Add IP).
1. A green banner should appear with a link to _Run Block Automation_.  Run this. This will configure the ZYNQ for your board, including configuring the DDR memory controller.
1. Add a _Processor System Reset_ IP to the design.
1. Add a _AXI Timer_ IP to the design.
1. Add a _AXI SmartConnect_ IP to the design.
1. Manually connect up the blocks like shown, or use the _Connection Automation_ tool to connect them.
<img src="{% link media/tutorials/block_diagram.png %}" width="800">
1. Open the _Address Editor_ and assign addresses to the _AXI Timer_ (right-click, _Assign Address_).
1. Go back to the _Diagram_ view and _Validate Design_.
1. Generate a top-level module: In the _Sources_ window, expand _Design Sources_ and right-click on your block design (_design_1.bd_) and select _Create HDL Wrapper_. Use the option to _Let Vivado manager wrapper and auto-update_.

### Committing to Git
Want to commit your project to Git? Don't try and commit your actual project files, as this won't work.  Instead, we will instruct Vivado to create a single Tcl script that can be used to re-create our project from scratch:
* Select _File->Project->Write Tcl_. 
* Make sure to check the box _Recreate Block Designs using Tcl_.  
* Those choose a file location.  This should be outside your project directory, since your project directory is temporary and not committed to Git.  My script is located at `lab_vitis/hw/create_hw_proj.tcl`.  Commit this Tcl script to Git.
* Now, feel free to delete your Vivado project folder, and then you can simply recreate it using `vivado -source create_hw_proj.tcl`.  I typically create a simple _Makefile_ such as this:

```
proj:
	vivado -source create_hw_proj.tcl

clean:
	rm -rf 625_lab5
```

### Synthesizing the hardware
1. Run _Generate Bitstream_.
1. Run _File->Export->Export Bitstream File_ and save the bitstream (*.bit* file) to your `lab_vitis/hw` directory.
1. Run _File->Export->Export Hardware_ and save the hardware description (*.xsa* file) to your `lab_vitis/hw` directory. This file will be provided to the software tools in the next section to tell the software tools all about our hardware system configuration.
1.  Commit these files to Git.


 <span style="color:red">**Important:**</span> Any time you change the hardware design (eg. changing your HLS IP) or block diagram.  You need to recompile the bitstream in Vivado, and re-export the bitstream and xsa file.  In addition, if you update your HLS designs, you will need to *Refresh* the IP in Vivado, *before* recompiling the bitstream.  Vivado keeps a cache of the IP, and if you don't refresh it, it will use the old IP.

### Next:  [Vitis Tutorial]({% link _pages/vitis_tutorial.md %})
