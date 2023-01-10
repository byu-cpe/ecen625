---
layout: lab
toc: true
title: Graphs & C++ Warmup
number: 1
repo: lab_graphs
---


## Learning Outcomes
The goals of this assignment are to:
* Familiarize yourself with graph algorithms that are most applicable to HLS techniques, namely topological sorting and identifying the critical path.
* Observe the structure of commercial HLS data flow graphs.
* Practice C++ skills.

## Preliminary
This assignent is located in the [lab_graphs](https://github.com/byu-cpe/ecen625_student/tree/main/lab_graphs) folder.  All commands shown assume you are located in that folder in your terminal.

### Install Packages
You will need the following packages:
```
sudo apt install cmake graphviz
```

### Extract Graphs
Due to size contraints on Github, the graphs are in a zip files and need to be extracted.  Run the following to extract the graphs:

```
make unzip_graphs
```


### Inspect the code
* `niGraphs/` -- This folder contains 2333 graphs of customer designs from National Instrument's HLS tool (LabVIEW Communications System Design Suite -- <https://www.ni.com/labview-communications/>).  Feel free to look at these files.  You will see each file defines a set of nodes and edges with associated properties.  As we progress through the class material you will learn more about these properties, but you can ignore most of them for now, aside from a few that are specifically mentioned in this assignment.
* `src/niGraphReader/` -- This contains the NIGraphReader class, which will parse the graph files into NIGraph* data structures.
* `src/niGraph/` -- This contains the NIGraph class, as well as NIGraphNode and NIGraphEdge classes, which are the data structures for the graphs.
* `src/main.cpp` -- You will need to implement several functions in this file.  You are free to split your code into additional files if you desire.

### Build the code
The project uses `cmake` as a build manager.  Cmake is a tool that will automatically create necessary makefiles for use with the `make` tool. The code can be built using the following commands:
```
cd build
cmake ../src
make
```

This will produce an executable located in `build/main`.  If you change any file contents, you only need to re-run `make` to recompile.  If you add new files, you will need to edit the [src/CMakeLists.txt](https://github.com/byu-cpe/ecen625_student/blob/main/lab_graphs/src/CMakeLists.txt) file.	

### main()

The provided main function can be run in two modes:

* **Mode 1: Selective graphs**: You can provide a list of graph numbers as arguments to main: 
```
./main 1 7 1300
```
For each graph this will perform topological sorting and print the sorted list of nodes, find the longest path, and generate a DOT file and PDF.  Statistics are printed to a `results.txt` file. _Note: Generating PDF files may not be possible for large graphs, and the program will stall._
	
* **Mode 2: All graphs**: If you provide no arguments, all graphs will be processed.  The sorted graph nodes won't be printed, and no DOT files will be generated.



## Requirements

The goal of this lab is to perform a topological sort of a dataflow graph, identify the longest delay path, and create a graph visualization.  [Graph 0]({% link media/graphs/graph0.pdf %}) shows a the graph for `DelayGraph_0.graphml`. 
Your graphs should have the following properties:
* Show all nodes and edges. Some nodes don't have edges.
* Nodes should be labeled with the node `id`, and the longest delay path to reach the node.
* Edges should be labeled with the edge `delay`.
* Edges along the longest delay path (ie, the critical path), should be colored red.  Some edges have delay=0; these edges can optionally be included in your critical path (it doesn't matter if you include them or not).
* The provided graphs are **_almost_** directed acyclic graphs (DAGs), except for a few _feedback edges_, which create cycles.  These feedback edges should be colored in blue.

### Code Checking
In addition to completing the code functionality described above, you code should also:
1. Build without warnings.  I have configured *clang-tidy* to be run when you compile your code.  This will enforce some extra checking that you might have not seen in the past.  Hopefully this will help you learn more about C++ best practises and improving your coding skills.  
1. Run in Valgrind without any reported issues.

These two checks are new for this year, so please reach out on Slack if you have questions.


### Part 1: Visualizing Graphs

You must write code to output an `NIGraph` structure in DOT language.  The code should be added to the following function:

```
void createDOT(const NIGraph &graph, const std::string outputPath,
    NIGraphNodeList &longestPath,
    std::map<NIGraphNode *, int> &nodeDelays) {
  
}
```

See <https://www.graphviz.org/content/dot-language> for the specification of the DOT language.  For example, a simple DAG with two nodes (`a` and `b`) and one edge (`delay = 3`) may have a DOT file like this:

```
strict digraph {
  a [label="a\n0"];
  b [label="b\n3"];
  a -> b [label=3; color=red];  
}
```

Although the graph visualization relies on the longest path data, it is included first in this document as visualizing the graphs can sometimes be helpful in debugging your sorting or longest path analysis code.  So, I suggest you complete the graph visualization without the longest path data first, then return and finish this step once you have the longest path analysis working.


### Part 2: Topological Sorting

You will write code to perform a topological sort of a graph.  See lecture slides or <https://en.wikipedia.org/wiki/Topological_sorting>.


The code should be added here:
```
NIGraphNodeList topologicalSort(const NIGraph &graph) {
  NIGraphNodeList q; 
  // add code here	  
  return q;
}
```

The function has a single input, an `NIGraph`, and returns a topologically sorted list of nodes (`NIGraphNode*`).    Since a topological sort is only possible for directed acyclic graphs (DAGs), you will need to <ins>ignore the feedback edges</ins>.  

### Part 3: Longest Path

In this last section you will write code to find the longest delay path in the graph, using the topologically sorted nodes from Part 2.  This code should be written in this function:
```
int longestDelayPath(const NIGraphNodeList &topolSortedNodes,
    NIGraphNodeList &longestPath,
    std::map<NIGraphNode *, int> &nodeDelays) {
  // add code here
}
```
The first arugment to this function is the topologically sorted list of nodes in the graph.  The function populates two data structures: `longestPath` should be populated with a list of nodes that make up the longest path, from start to finish, and `nodeDelays` provides a map indicating the longest delay to each node in the graph.  The delay of the longest path is returned from the function.

See lecture slides, [wikipedia](https://en.wikipedia.org/wiki/Longest_path_problem), or search on the web for how to determine the longest path from a topological sort. For a DAG, the longest delay path is also known as the _critical path_.  This term is likely familiar to you in the circuit domain, as combinational logic can be represented using a DAG, and the critical path restricts the maximum frequency of the circuit.  

Again, to ensure the graph is a DAG, you will \uline{need to ignore feedback edges}. Remember to ignore these edges when finding the longest back, and during the backtracking portion.


## Deliverables

* Make sure your code is pushed up to your Github repo.   

* Add a 1 page PDF report, that includes a short paragraph about how your topological sorting algorithm works.  Include a [scatter plot](https://en.wikipedia.org/wiki/Scatter_plot), which plots the run-time for your topological sort code for  **ALL** 2333 of the provided graphs.  The plot should be of the following format:
    * The x-axis should show the size of the graph (V + E)
	* The y-axis should show the runtime of the topological sorting.
	* Both the x and y axis should be in logarithmic scale, with appropriate ranges to fit your data points.

There are many ways to do a topological sort.  For full marks, your chart data should show that your algorithm complexity is approximately `O(V+E)`.  Please don't spend extra time performing analysis to show this; a visual inspection of the scatter plot is fine.

* Include the following data using your longest path code:

| Graph | size (V+E) | Delay |
|:------|-----------:|------:|
|DelayGraph_0 |  197| 8077 |
|DelayGraph_1  |  | 
|DelayGraph_2  |  | 
|DelayGraph_3  |  | 
|DelayGraph_4  |  | 
|DelayGraph_5  |  | 
|DelayGraph_6  |  | 
|DelayGraph_7  |  | 
|DelayGraph_8  |  | 
|DelayGraph_9  |  | 
|DelayGraph_10 |  | 

	
* Include the longest path for DelayGraph_3.  For example, the longest path for DelayGraph_0 is:
```
n0 -> n14 -> n15 -> n19 -> n21 -> n23 -> n24 -> n25 -> n26 -> n27 -> 
n29 -> n43 -> n44 -> n50 -> n51 -> n56 -> n60 -> n70 -> n71 -> n74 -> 
n75 -> n78 -> n76 -> n77 -> n79 -> n80 -> n81 -> n82 -> n83 -> n84 -> 
n88
```

## Submission Instructions

Submit your code using a Github tag: `lab1_submission`.
Instructions are provided [here]({% link _pages/lab_setup.md %}#submitting-code)
