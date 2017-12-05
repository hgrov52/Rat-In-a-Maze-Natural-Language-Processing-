:- module(mazeInfo, [info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).


info(6, 6, c).

wall(4,0).

wall(1,1).
wall(2,1).
wall(3,1).

wall(5,2).

wall(1,3).
wall(2,3).
wall(4,3).

wall(4,4).

wall(0,5).

button(0,2,1).
button(1,0,2).
button(1,2,3).

num_buttons(3).

start(4,1).

goal(5,3).