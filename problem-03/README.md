---
title: "problem-03"
author: "Vishal Paudel"
date: "2025/01/24"
format:
  docx:
    fig-align: center
---

> 3. More ODE & animation practice. Take a simple set of ODEs. Use a set you like,e.g., harmonic oscillator, non-linear pendulum, the Lorentz system (look it up on the internet). Solve this set numerically 3 ways (see below), and understand the accuracy. The goal is that, by the time you hand in the homework, you can write and debug the assignment on your own without looking up anything (outside of trivial syntax things). And you always have a good sense of the accuracy of your solution.
>     a. Method 1: as simply as possible, without ODE45, and without calling functions or anything like that. A single function or script file with no function calls (ok, plotting calls are ok). Just write a simple loop that implements Euler’s method with your ODE.
>     b. With your own Euler solver function. Your main program should call your Euler solver. Your Euler solver should call a RHS (Right Hand Side) function.
>     c. With ODE45.
>     d. Using (b), solve the equations many times with progressively smaller step size, down to the smallest size you have patience for, and up to the largest size that isn’t crazy. As sensibly as possible, compare the results and use that comparison to estimate the accuracy of each solution. You should be able to find a method to estimate the accuracy of a numerical solution even without knowing the exact solution.
>     e. Using ODE45, solve the equations with various accuracies (use ’reltol’ and ’abstol’, note MATLAB satisfies one or the other, whichever is easiest. So, if you want an accurate solution you need to make both ’reltol’ and ’abstol’ small). Does Matlab do a good job of estimating its own accuracy? Use suitable plots to make your point.

### Write a single file or function write eulers method
