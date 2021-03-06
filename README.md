# Fibonacci Optimized π―

Some computations are naturally time-consuming and have very little room for optimization, such as the Fibonacci sequence; knowing this, the standard way of doing things in Flutter can be slow and jittery as everything is being processed in an event loop.

## What has been done π

- A single page app that has counter and a fibonacci value of that counter.β
- **Bloc** was used in the projectβ
- Using an **optimized** function to calculate the **fibonacci** with loops.β
- Making the function work in background using **Isolate** and **compute** function. β
- Adding loading indicator for the function in the UI.β
- Table of the data that is going through the process was maintained in a map with a status of the **fibonacci** background operation. β

β Plus:

- Adding CI for the project using github actions.β

___

A small article i made about this, hope you like it π
[Faster Fibonacci](https://sof9816.medium.com/faster-fibonacci-efde16a7d312)
