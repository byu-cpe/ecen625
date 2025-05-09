---
title: Lab Setup
layout: page
toc: true
sidebar: true
icon: fas fa-wrench
---

## Prerequisite Skills
In this class you are expected to be familiar with the Linux command line, Git and Github.  If you haven't used these tools before, here are links to a few tutorials:

* <https://ryanstutorials.net/linuxtutorial/>
*	[Learn Git in 15 minutes](https://www.youtube.com/watch?v=USjZcfj8yxE)
* [Learn Github in 20 minutes](https://www.youtube.com/watch?v=nhNq2kIvi9s)

## Environment

The assignments assume you are running an Ubuntu 24.04 Linux Operating System.  You may be able to complete some assignments on other Linux variants; however, for the assignments that use the Xilinx Vivado tools, you will need a supported operating system.

You will need a Linux OS environment set up to complete the assignments.  A few options:
* You install a full Ubuntu image (including Xilinx tools) in Windows using [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).  
* You can set up a computer with Linux, or even dual-boot Linux and Windows/MacOS (dual-boot is a bit more complicated than these other options).
* Alternatively, I have a server available that you can ssh into.  You will have to be connected to the CAEDM VPN to use this, so if you choose this option, make sure you have a good internet connection. If you want to go this route, please email me your desired username and I will create a login for you.

_Note:_ The Xilinx Vitis tool that we will be using requires about 80-90GB of disk space.  So whatever option you choose, make sure you give yourself plenty of room.

## Tools
Some notes on software tools we will be using.
* I recommend you use VS Code for code editing as the repository is preconfigured for VS Code.
* We will be using Xilinx's Vitis 2024.2 tool, but not starting until Lab 4.
* The earlier labs will only use open-source software available via apt.  Make sure you have sudo permissions on your Linux machine so that you can install the necessary packages (ie. you can't complete the class labs using the CAEDM servers).

## Class Repository
1. You must use this invitation link to set up a Github classroom repo for the class: <https://classroom.github.com/a/2I46beht>

1. This will create a blank repository for you. 

1. Your repository will begin empty, but you will need to import the starter code.  To do this we will do a bare clone of the starter code repository, and push it to your repository.  Then you can delete this clone.  Make sure to replace the URL in the third step with the URL of your repository, that you can find by clicking the *SSH* button on your repository page.  You can run these commands in any directory you want. 

        git clone --bare git@github.com:byu-cpe/ecen625_student.git
        cd ecen625_student.git/
        git push --mirror git@github.com:byu-ecen625-classroom/625-labs-jgoeders.git
        cd ..
        rm -rf ecen625_student.git


### Clone your Repo

  - Go to your newly created repo.  
  - Click the **Code** button, and then the **Use SSH** link
  - Copy the URL that is shown.  It should be something like: *git@github.com:byu-cpe-classroom/625-labs-\<your_id\>.git*
  - Clone the repository into a directory you want to use, for example:  

        git clone <github_ssh_address> ~/625

  - Open this in VS Code by running `code ~/625`


## Getting Code Updates
If for some reason, I need to fix a problem with the starter code, you will need a way of pulling those changes down onto your computer. The easiest approach is to create another remote for your git repo. By default, you will have one remote, `origin`, which will point to your GitHub repo. Add another one using the following command:

```
  git remote add startercode https://github.com/byu-cpe/ecen625_student.git
```

If you ever need to pull down changes I made (I will let you know when this is the case), you can do the following:

```
git pull startercode main
```

## Submitting Code
Lab submissions will be done by creating a tag in your Git repository.  You can do this like so:

```
git tag lab1_submission
git push origin lab1_submission
```

If, after you create this tag, you want to change it (ie, re-submit your code), you can re-run the above commands and include the --force option, ie:
```
git tag --force lab1_submission
git push --force origin lab1_submission
```