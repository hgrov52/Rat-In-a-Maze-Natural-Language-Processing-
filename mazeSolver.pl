:- module(mazeSolver, [main/0]).
:- use_module(mazeInfo,[info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).


isA(a).
isC(c).

equal(X,Y) :-
	X=:=Y.

notEqualToLastLoc(X,Y,LastX,LastY) :-
	(equal(X,LastX),equal(Y,LastY) -> false; true).


isValid(X,Y,LastX,LastY) :-
	mazeInfo:info(W,H,_),

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

	% get info from the info module
	mazeInfo:info(W,H,Type),
	mazeInfo:start(X,Y),
	mazeInfo:num_buttons(N),

	%Stream is the output file to write to  
    open('path-solution.txt',write, Stream),

	write("The board is "),write(W),write(" by "),write(H),write(" and is type "),write(Type),write(" and has "),write(N),write( " buttons"), nl,
	write("The start point is: "),write(X),write(","),write(Y),nl,nl,
	
	% if statement syntax
	( isA(Type) -> simulateA(X,Y,Stream) ; simulateC(X,Y,1,Stream) ),
	

	write("end").

simulateA(StartX, StartY,_) :- 
	write("Sim A"),nl,
	write("Starts at "),write(StartX),write(","),write(StartY),nl.

simulateC(StartX, StartY, ButtonNum,Stream) :- 
	%nl,write("Sim C"),nl,
	mazeInfo:num_buttons(N),
	mazeInfo:goal(GoalX,GoalY),
	
	% If the Button ID is greater than the number of buttons, then find a path to the goal
	( (ButtonNum > N) -> format('Goal is at ~w,~w~n',[GoalX,GoalY]),findPath(StartX, StartY, GoalX, GoalY, [], -1,-1,ButtonNum,true,Stream);write("")),

	write("looking for button number "),write(ButtonNum),nl,

	mazeInfo:button(ButtonX,ButtonY,ButtonNum),

	write("Button "),write(ButtonNum),write(" is at: "),write(ButtonX),write(","),write(ButtonY),nl,
	write(""),

	findPath(StartX, StartY, ButtonX, ButtonY,[], -1,-1,ButtonNum,false,Stream).

findPath(StartX,StartY,EndX,EndY,Path,LastX,LastY,ButtonNum,FindingGoal,Stream) :-
	%write("In find path at "),write(StartX),write(","),write(StartY), nl,
	
	(equal(StartX,EndX),equal(StartY,EndY),FindingGoal -> printLastPath(StartX,StartY,Path,Stream) ; write("")),
	

	(equal(StartX,EndX),equal(StartY,EndY) -> printPath(StartX,StartY,ButtonNum,Path,Stream) ; write("")),

	inc(StartX,StartXPlusOne),
	inc(StartY,StartYPlusOne),
	dec(StartX,StartXMinusOne),
	dec(StartY,StartYMinusOne),

	append(Path,[[StartX,StartY]],NewPath),
	
	( isValid(StartX,StartYPlusOne,LastX,LastY) -> findPath(StartX,StartYPlusOne, EndX,EndY,NewPath,StartX,StartY,ButtonNum,FindingGoal,Stream);write("")),

	( isValid(StartXPlusOne,StartY,LastX,LastY) -> findPath(StartXPlusOne,StartY, EndX,EndY,NewPath,StartX,StartY,ButtonNum,FindingGoal,Stream);write("")),
	( isValid(StartXMinusOne,StartY,LastX,LastY) -> findPath(StartXMinusOne,StartY, EndX,EndY,NewPath,StartX,StartY,ButtonNum,FindingGoal,Stream);write("")),
	( isValid(StartX,StartYMinusOne,LastX,LastY) -> findPath(StartX,StartYMinusOne, EndX,EndY,NewPath,StartX,StartY,ButtonNum,FindingGoal,Stream);write("")),

	write("").

print([],_).
print(Path,Stream):-

	Path = [ H | T],
	H = [ X | Y ],
	Y = [G],
	write(Stream,"["),write(Stream,X),write(Stream,","),write(Stream,G),write(Stream,"]"),write(Stream,"\n"),

	print(T,Stream).

printPath(X,Y,ButtonNum,Path,Stream) :-
	%write(Path),nl,
	print(Path,Stream),
	write("Found Button "),write(ButtonNum),nl,
	inc(ButtonNum,NewButtonNum),
	simulateC(X,Y,NewButtonNum,Stream).

printLastPath(X,Y,Path,Stream) :-
	write("done with simulation"),nl,
	print(Path,Stream),
	write(Stream,"["),write(Stream,X),write(Stream,","),write(Stream,Y),write(Stream,"]"),
	write("Found Goal"),nl,
	write("Terminating Program"),
	% Terminate Program
	close(Stream),
	fail.


% Will there be boards without buttons?
% will there ever be a b or c type board with no buttons?