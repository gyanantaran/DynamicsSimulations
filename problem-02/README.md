---
title: "problem-02"
author: "Vishal Paudel"
date: "2025/01/24"
format:
  docx:
    fig-align: center
---

> 2. 3D. Get good at vectors. Assume that the positions relative to an origin of four random points, which are randomly located in space are given as $\vec{\mathbf{r_A}}$, $\vec{\mathbf{r_B}}$, $\vec{\mathbf{r_C}}$ and $\vec{\mathbf{r_D}}$. Assume force $\vec{\mathbf{F}}$ is given. For each problem below write a single vector formula (one for each problem) that answers the question.
>     a) The points A and B define an infinite line. So do the points C and D. Find the distance between these two lines. ‘The’ distance means ‘the minimum distance’, that is the length of the shortest line segment connecting the two lines. Either write a formula (or sequence of formulas), or write computer code that gives the answer, or both.
>     b) Same problem as above, but also find the end points of the shortest line segment.
>     c) Find the volume of the tetrahedron ABCD (you should reason-out and not quote any formulas for the volume of a tetrahedron, that is, see if you can derive the formula: ’volume = one third base times height’).
>     d) Assume points A, B and C are fixed to a structure. All three are connected, by massless rods, to a ball and socket at each end, to point D. At point D the force  F is applied. Find the tension in bar AD. Find a formula for the answer, or write computer code to find the answer, or both. The goal is to find a formula for the tension in terms of the positions and the force vector.

### a) Write formula or code for the length of the shortest line segment

The lines can be represented as:
$$l_1: \quad \vec{\mathbf{r_A}} + \lambda_1 (\vec{\mathbf{r_B}}-\vec{\mathbf{r_A}})$$
$$l_2: \quad \vec{\mathbf{r_C}} + \lambda_2 (\vec{\mathbf{r_D}}-\vec{\mathbf{r_C}})$$

Hence, for two points on either lines, $p_1$, $p_2$:

$$D(\lambda_1, \lambda_2) = \quad \left|\left| \vec{\mathbf{p_2}} - \vec{\mathbf{p_1}} \right|\right|_n$$

Which can be framed as an optimisation problem, minimum length, $\hat{d}$:

$$\hat{d} = \quad \min_{\lambda_1, \lambda_2} || \left( \vec{\mathbf{r_A}} + \lambda_1 (\vec{\mathbf{r_B}}-\vec{\mathbf{r_A}}) - (\vec{\mathbf{r_C}} + \lambda_2 (\vec{\mathbf{r_D}}-\vec{\mathbf{r_C}})) \right) ||_n$$

or,

$$\hat{d} \leftarrow D\left( \quad \nabla D(\lambda_1, \lambda_2) = 0 \quad\right)$$
### b) Also find the end points of the shortest line segment

The formulation above can be used:

$$\left(\hat{\lambda_1}, \hat{\lambda_2}\right) \leftarrow \texttt{argmin}\underset{\lambda_1, \lambda_2} D(\lambda_1, \lambda_2)$$

$p_1$ and $p_2$ correspond to $\lambda_1$ and $\lambda_2$ through the equations for the lines.

### c) Find the volume of the tetrahedron

I was convinced that a tetrahedron is geometric one-sixth of a parallelapiped, therefore, volume $V(\vec{\mathbf{r_a}}, \vec{\mathbf{r_b}}, \vec{\mathbf{r_c}}, \vec{\mathbf{r_d}})$ is (assuming the vectors are in three dimensions for cross product to work):

$$V(\vec{\mathbf{r_a}}, \vec{\mathbf{r_b}}, \vec{\mathbf{r_c}}, \vec{\mathbf{r_d}}) = \frac{1}{6} \left|(\vec{\mathbf{r_c}} - \vec{\mathbf{r_b}}) \times (\vec{\mathbf{r_c}} - \vec{\mathbf{r_a}}) \cdot (\vec{\mathbf{r_d}} - \vec{\mathbf{r_d}})\right|$$

### d) Write formula or code for the tensions in the rods

$$\vec{\mathbf{F}} + T_{ad}\hat{r_{ad}} + T_{bd}\hat{r_{bd}} + T_{cd}\hat{r_{cd}} = \vec{\mathbf{0}}$$
There was an in-class mention about Cramer's rule to solve this. There are three equations and three unknowns, but one could use Gaussian-elimination.