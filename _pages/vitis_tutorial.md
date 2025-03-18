---
layout: page
toc: false
title: Vitis Tutorial
---

### Previous: [Vivado Tutorial]({% link _pages/vivado_tutorial.md %})


## Create Vitis Projects

Run Vitis (`vitis`), and choose a workspace location. I used _lab_vitis/sw_ for my workspace location.


### Create the platform component

The platform project generates the _standalone_ software layer code, which provides a software layer to access hardware and processor features (timers, interrupts, etc) in a bare-metal environment.
  1. _File->New Component->Platform_.  
  1. Chose a _Component name_.  I chose *625_hw*.  
  1. On the next tab you must select the hardware design.  Browse to your _.xsa_ file.  
<img src = "{% link media/tutorials/hw_platform.png %}" width="700" alt="Wizard image of hardware platform selection">
  1. On the next tab, select the *standalone* operating system (i.e. bare metal), and choose the *ps7_cortexa9_0* processor.  Leave *Generate Boot artifacts* checked.
  1. Click *Finish*.
  1. Change the _stdout_ output.  By default, the output from your program will be sent over the physical UART pins present on the board.  But instead of having to connect a UART to the board, we will use the option that allows us to send stdout over an virtual UART using the JTAG (USB) connection.
  * Expand your platform component, and double click on the _Settings->vitis-comp.json_ file.  Select the *standalone_ps7_coretexa9_0->Board Support Package->standalone* menu, and change _standalone_stdout_ to use *ps7_coresight_comp_0*.  
<img src = "{% link media/tutorials/bsp_stdout.png %}" width="800" alt="BSP stdout selection">
  1. Build the BSP code using the *Build* button in the *Flow* section in the bottom-left.

### Create the application component
  1.  _File->New Component->Application_.
  1. Choose a component name (ie. 625_sw), and continue through the next screens.
  1. Chose your platform that you created in the last step.
<img src = "{% link media/tutorials/vitis_application.png %}" width="800" alt="Wizard menu for application selection">
  1. Select the only available domain (*standalone_ps7_coretexa9_0*).
  1. Skip past the *Add Source Files* tab, and click *Finish*. 
  
  1. Create a simple application.  Right-click on your *src* directory in your application component, and choose *New File*. Add a *main.cpp* file with the following code: 
```
#include <stdio.h>  
int main() {
  printf("Hello World\n");
}
```
  1. Build your application.  Change the flow in the bottom-left to your application component, and click *Build*.


## Run Your Applicaton on the Board
*  Right-click on your executable folder (down one level from the *_system* project created in the last step -- see image below), choose *Run As->Launch on Hardware (Single Application Debug*.  
<img src = "{% link media/tutorials/run_program.png %}" width="800" alt="Right click menu to run program on hardware">

* To view the program output, you will need to use the console selector button in the *Console window to select the *TCF Debug Virtual Terminal - ARM Cortex-A9 MPCore #0* console.  This is the JTAG console for core 0.
<img src = "{% link media/tutorials/select_console.png %}" width="800" alt="Menu to select proper console output">

* You should see the message *Hello World*.

### Next:  [Vitis HLS Integration Tutorial]({% link _pages/hls_integration_tutorial.md %})
