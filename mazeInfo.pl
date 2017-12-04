:- module(mazeInfo, [info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).


info(5, 5, c).

wall(0,0).
wall(1,0).
wall(2,0).
wall(3,0).
wall(4,0).

wall(3,1).

wall(1,2).
wall(2,2).
wall(5,2).

wall(4,3).

wall(0,4).
wall(2,4).
wall(4,4).

wall(0,5).

button(4,3,1).
button(0,1,2).

num_buttons(2).

start(4,1).

goal(5,3).