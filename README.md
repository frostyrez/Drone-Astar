# Drone-Astar

## The Project

A crucial obstacle standing in the way of widespread commercial use of drones in urban areas is it's struggling ability to autonomously navigate and adapt to a constantly changing urban environment, full of static and dynamic hazards. Regulatory frameworks are stringent, rightfully so, and proving that a drone is able to safely navigate an urban environment is a complex engineering task.

In this project, a quadcopter controller is built up from first principles using MPC theory to ensure it is fully autonomous and robust. The controller is then packaged up into a GUI using MATLAB App Designer. The app allows the user to either choose from a selection of pre-defined urban environments or to create an entirely novel situation for the quadcopter to navigate. Once start and target coordinates are inputted, the user can choose how many fixed obstacles (buildings) and moving obstacles (other aircraft) will be included in the simulation. The buildings are modelled as cylinders where height, radius, and (x,y) center position are inputted. The moving obstacles are defined as (x,y) center positon, radius, and height above ground. A direction is then selected for all moving obstacles.

<p align="center">
<img width="494" alt="image" src="https://github.com/frostyrez/Drone-Astar/assets/123249055/f970a4bf-42cd-444d-b0da-299b4f4281f7">
</p>
<p align="center">
<i> Dynamic A* Quadcopter App. Last frame of the "Clear Day Climb" scenario. </i>
</p>

Once the go button is pressed in the bottom right, the A* algorithm begins, cycling through timesteps until the target node is reached. Note that the higher-level program has been optimised to only call A* if the optimal path is suddenly obstructed, otherwise the drone will proceed to the next node.

Feel free to download and play with `AStarApp.mlapp`. Additional MATLAB toolboxes may need to be installed.

## The Algorithm

Popular path-finding algorithms were initially researched such as Potential Field, Floyd-Warshall, Genetic Algorithm, and A*. I noted the following traits, and concluded that A* was best suited for this application:

| **Potential Field**                                                                                                                                                                              | **Floyd-Warshall**                                      | **Genetic Algorithm**                                               | **_A<b>*</b> Algorithm_**                                  |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|---------------------------------------------------------------------|---------------------------------------------------|
| Artificial Potential field assigned to every point in the world                                                                                                                                  | Subset of Dynamic Programming                           | Evolutionary algorithm inspired by the process of natural selection | “Estimated cost to target” is a heuristic         |
| Goal node has lowest potential and starting node has highest potential, obstacles and no-fly-zones also having high potential, so the UAV is pulled towards goal whilst obstacles push UAV away. | Finds shortest path between all pairs of vertices       | Does not scale well with complexity                                 | Popular in games such as Pacman and Tower defense |
| Poor optimization in narrow passages, dynamic environments, and symmetrical obstacles                                                                                                            | Improvement upon Dijkstra’s and Bellman-Ford algorithms |                                                                     | Relies heavily on heuristics                      |


The way A* is applied here is best explained in the following two flow charts from my report, one which details the static version of the algorithm, and the other which covers the dynamic version. They are more readable in my report where they have been spread across pages 14-19.
<p align="center">
<img width="264" alt="image" src="https://github.com/frostyrez/Drone-Astar/assets/123249055/5d8c2504-cefd-4ae5-a5c2-626fd99e8127">
</p>
<p align="center">
<i> A* Flow Charts </i>
</p>

### Time Complexity and Optimisations

Because the time complexity of the path-finding algorithm can vary between simulations depending on the efficiency of the heuristic in that given state space, an effort was made to estimate the time complexity by recording the increase in computational time as the state space scaled up from 10x10 to 50x50x50. Other features and optimisations also had their impact on computational time recorded. A few conclusions:

- Version 5: Increasing the map size by 125 times led to a 221-fold increase in computational time.
- Version 6: Only calling A* when the optimal path is no longer available cut computational time by roughly half.
- Versions 7 and 8: Reducing the number of directions the drone can travel in successively cut computational time by 31% and 62%.

<p align="center">
<i> Version History </i>
</p>

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
