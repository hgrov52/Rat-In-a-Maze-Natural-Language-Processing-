:- module(mazeInfo, [info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).


info(5, 5, c).

wall(1,0).
wall(1,1).
wall(1,2).
wall(1,3).

wall(3,1).
wall(3,2).
wall(3,3).
wall(3,4).

button(4,3,1).
button(0,1,2).

num_buttons(2).

start(0,0).

goal(4,4).