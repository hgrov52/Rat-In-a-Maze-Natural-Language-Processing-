:- module(mazeSolver, [main/0]).
:- use_module(mazeInfo,[info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).


isA(a).
isB(b).
isC(c).

equal(X,Y) :-
	X=:=Y.

notEqualToLastLoc(X,Y,LastX,LastY) :-
	(equal(X,LastX),equal(Y,LastY) -> false; true).


isValid(X,Y,LastX,LastY) :-
	mazeInfo:info(W,H,Type),

	(X < 0 -> false;write("")),
	(Y < 0 -> false;write("")),
	(X > W-1 -> false;write("")),
	(Y > H-1 -> false;write("")),

	notEqualToLastLoc(X,Y,LastX,LastY),

	(mazeInfo:wall(X,Y)->false;true),

	true.


inc(X,X1) :-
	X1 is X+1.

dec(X,X1) :-
	X1 is X-1.
	


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
	( isA(Type) -> simulateA(X,Y) ; simulateC(X,Y,1) ),
	

	write("end").

simulateA(StartX, StartY) :- 
	write("Sim A"),nl.

simulateB(StartX, StartY, ButtonNum) :-
	write("Sim B"),nl,
	write("This is also a valid path under Sim C.."),nl,
	write("Passing to "),
	simulateC(StartX, StartY, ButtonNum).

simulateC(StartX, StartY, ButtonNum) :- 
	%nl,write("Sim C"),nl,
	mazeInfo:num_buttons(N),
	mazeInfo:goal(GoalX,GoalY),
	write("N: "),write(N),nl,
	% If the Button ID is greater than the number of buttons, then find a path to the goal
	write("Goal "),write(GoalX),write(","),write(GoalY),
	nl,
	( (ButtonNum > N) -> findPath(StartX, StartY, GoalX, GoalY, [], -1,-1,ButtonNum,true);write("")),

	write("looking for button number "),write(ButtonNum),nl,

	mazeInfo:button(ButtonX,ButtonY,ButtonNum),

	write("Button "),write(ButtonNum),write(" is at: "),write(ButtonX),write(","),write(ButtonY),nl,
	write(""),

	findPath(StartX, StartY, ButtonX, ButtonY,[], -1,-1,ButtonNum,false).

findPath(StartX,StartY,EndX,EndY,Path,LastX,LastY,ButtonNum,FindingGoal) :-
	%write("In find path at "),write(StartX),write(","),write(StartY), nl,
	
	(equal(StartX,EndX),equal(StartY,EndY),FindingGoal -> printLastPath(StartX,StartY,ButtonNum,Path) ; write("")),
	

	(equal(StartX,EndX),equal(StartY,EndY) -> printPath(StartX,StartY,ButtonNum,Path) ; write("")),


	inc(StartX,StartXPlusOne),
	inc(StartY,StartYPlusOne),
	dec(StartX,StartXMinusOne),
	dec(StartY,StartYMinusOne),
	
	( isValid(StartX,StartYPlusOne,LastX,LastY) -> findPath(StartX,StartYPlusOne, EndX,EndY,append(Path,[StartX,StartY]),StartX,StartY,ButtonNum,FindingGoal);write("")),

	( isValid(StartXPlusOne,StartY,LastX,LastY) -> findPath(StartXPlusOne,StartY, EndX,EndY,append(Path,[StartX,StartY]),StartX,StartY,ButtonNum,FindingGoal);write("")),
	( isValid(StartXMinusOne,StartY,LastX,LastY) -> findPath(StartXMinusOne,StartY, EndX,EndY,append(Path,[StartX,StartY]),StartX,StartY,ButtonNum,FindingGoal);write("")),
	( isValid(StartX,StartYMinusOne,LastX,LastY) -> findPath(StartX,StartYMinusOne, EndX,EndY,append(Path,[StartX,StartY]),StartX,StartY,ButtonNum,FindingGoal);write("")),




	write("").

print([]):-
	write("").
print(H|T):-
	write(H),
	print(T).


printPath(X,Y,ButtonNum,Path) :-
	write("printing path"),nl,
	print(Path),

	inc(ButtonNum,NewButtonNum),
	simulateC(X,Y,NewButtonNum).

printLastPath(X,Y,ButtonNum,Path) :-
	write("done"),nl,

	write("ButtonNum is "),write(ButtonNum),

	fail.




% Will there be boards without buttons?
% will there ever be a b or c type board with no buttons?