:- module(mazeSolver, [main/0]).
:- use_module(mazeInfo,[info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).


isA(a).
isB(b).
isC(c).


main :-

	
	part1().

	

part1() :-
	% info (Width, Height, Test Type (a, b, or c))
	% wall (X coordinate, Y coordinate)
	% button (X coordinate, Y coordinate, Button ID (for button order))
	% num_buttons (number of buttons in the maze)
	% start (X coordinate, Y coordinate)
	% goal (X coordinate, Y coordinate)

	% Plan: develop solution for test type c
		% Needed Functions:

			% Main functions

				% findNextButton
				% findGoal 
				% findPath(X,Y) given current location

			% Helper Functions:

				% getPossibleMoveDirections(X,Y) given current location
				% 

			% Concepts 
				% Label certain locations as bad to prevent moving there again
				% Until you havent hit all buttons, path find
				% find path will use recursive path finder until goal is found
	
	% get info from the info module
	mazeInfo:info(W,H,Type),
	mazeInfo:start(X,Y),
	mazeInfo:num_buttons(N),

	write("The board is "),write(W),write(" by "),write(H),write(" and is type "),write(Type),write(" and has "),write(N),write( " buttons"), nl,
	write("The start point is: "),write(X),write(","),write(Y),nl,
	
	% if statement syntax
	( isA(Type) -> simulateA(X,Y) ; simulateC(X,Y,1) ).

simulateA(StartX, StartY) :- 
	write("Sim A"),nl.

simulateB(StartX, StartY, ButtonNum) :-
	write("Sim B"),nl,
	write("This is also a valid path under Sim C.."),nl,
	write("Passing to "),
	simulateC(StartX, StartY, ButtonNum).

simulateC(StartX, StartY, ButtonNum) :- 
	nl,write("Sim C"),nl,
	mazeInfo:num_buttons(N),
	mazeInfo:goal(GoalX,GoalY),

	( (ButtonNum > N) -> findPath(StartX, StartY, GoalX, GoalY, [], true);write("")),

	write("looking for button number "),write(ButtonNum),nl,

	mazeInfo:button(ButtonX,ButtonY,ButtonNum),

	write("Button "),write(1),write(" is at: "),write(ButtonX),write(","),write(ButtonY),nl,
	write(""),

	findPath(StartX, StartY, ButtonX, ButtonY,[], false).

findPath(StartX,StartY,EndX,EndY,Path,FindingGoal) :-
	write("In find path"),

	(mazeInfo:goal(StartX,StartY) -> printPath(Path) ; write("")),





	write("").

printPath(Path) :-
	write("printing path").




% Will there be boards without buttons?
% will there ever be a b or c type board with no buttons?