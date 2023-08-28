# Drone-Astar

A similarly important problem facing the widespread adoption of drones in urban areas, in addition to the robust autonomous controller discussed in the FYP directory, is the drone's ability to navigate a constantly changing urban environment, full of static and dynamic obstacles.

This project resulted in the creation of a MATLAB app as shown below. The front-end code was written in MATLAB's App Designer software, and allows the user to either choose from a selection of pre-defined urban environments or to create an entirely novel situation for the quadcopter to navigate. Once start and target coordinates are inputted, the user can choose how many fixed obstacles (buildings) and moving obstacles (other aircraft) will be included in the simulation. The buildings are modelled as cylinders where height, radius, and (x,y) center position are requested. The moving obstacles are defined as (x,y) center positon, radius, and height above ground. A direction is then selected for all moving obstacles to move in.

<p align="center">
<img width="494" alt="image" src="https://github.com/frostyrez/Drone-Astar/assets/123249055/f970a4bf-42cd-444d-b0da-299b4f4281f7">
</p>
<p align="center">
Dynamic A* Quadcopter App. Last frame of the "Clear Day Climb" scenario.
</p>

Once the go button is pressed in the bottom right, the A* algorithm begins, cycling through timesteps until the target node is reached. Note that the higher-level program has been optimised to only call A* if the optimal path is suddenly obstructed, otherwise the drone will proceed to the next node.

# The A* Algorithm

Various path-finding algorithms were initially researched that could potentially scale well with grid size, such as Potential Field, Floyd-Warshall, Genetic Algorithm, and A* (see report.pdf, page 12).
The way the A* algorithm theory is applied here is best explained in the following two flow charts from my report, one which details the static version of the algorithm, and the other which covers the dynamic version. It is broken down across several pages in the report, pages 14-19.
<p align="center">
<img width="264" alt="image" src="https://github.com/frostyrez/Drone-Astar/assets/123249055/5d8c2504-cefd-4ae5-a5c2-626fd99e8127">
</p>
<p align="center">
A* Flow Charts
</p>

Because the time complexity of the path-finding algorithm can vary between simulations depending on the efficiency of the heuristic in that given state space, an effort was made to estimate the time complexity by recording the increase in computational time as the state space scaled up from a 10x10 array to a 50x50x50 state space. The version history is displayed below, with time to execute and the factor change from the previous version. Note the 221-fold increase in computational time from the 125-fold increase map size, from 1000 cells to 125000.

| **Version** | **Category** | **Improvement**                                                 | **Time to execute (s)** | **Factor** |
|-------------|--------------|-----------------------------------------------------------------|-------------------------|------------|
| 1           | Fundamentals | 2D 10x10 Grid, fixed obstacles                                  | 0.28                    | -          |
| 2           | Search Area  | 3D 10x10x10 grid                                                | 0.32                    | 1.14       |
| 3           | Obstacles    | Moving obstacles, path reset after each timestep                | 0.47                    | 1.47       |
| 4           | Obstacles    | Fixed and moving obstacles simultaneously                       | 0.53                    | 1.13       |
| 5           | Search Area  | Increased to a 50x50x50 Grid                                    | 117                     | 221        |
| 6           | Path reset   | 3D Grid, fixed and moving obstacles, reset only if path crossed | 49                      | 0.42       |
| 7           | Direction    | Backwards travel disallowed                                     | 34                      | 0.69       |
| 8           | Direction    | Backwards and lateral travel disallowed                         | 13                      | 0.38       |
| 9           | Interface    | GUI created                                                     | -                       | -          |
