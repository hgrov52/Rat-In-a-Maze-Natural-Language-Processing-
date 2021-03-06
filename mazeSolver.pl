:- module(mazeSolver, [main/0]).
:- use_module(mazeInfo,[info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).
:- use_module('NLParser',[interpretValidSentence/4]).

isA(a).
isC(c).

equal(X,Y) :-
	X=:=Y.

notEqualToLastLoc(X,Y,LastX,LastY) :-
	(equal(X,LastX),equal(Y,LastY) -> false; true).


isValid(X,Y,LastX,LastY,Path,ButtonNum) :-
	mazeInfo:info(W,H,_),

	(X < 0 -> false;write("")),
	(Y < 0 -> false;write("")),
	(X > W-1 -> false;write("")),
	(Y > H-1 -> false;write("")),
	notEqualToLastLoc(X,Y,LastX,LastY),
	(member([X,Y],Path)->false;write("")),
	(mazeInfo:wall(X,Y)->false;write("")),
	(mazeInfo:button(X,Y,BNum)->(BNum>ButtonNum->false;write(""));write("")),
	
	true.

isValidNL(StartX,StartY,EndX,EndY):-
	mazeInfo:info(W,H,_),

	%boundaries
	(EndX < 0   ->false;write("")),
	(EndX > W-1 ->false;write("")),
	(EndY < 0   ->false;write("")),
	(EndY > H-1 ->false;write("")),

	%wall in between 
	(wallBetween(StartX,StartY,EndX,EndY)->false;write("")),

	true.

wallBetween(X,Y,A,B):-
	(X=:=A,Y=:=B->false
		;
		(X=:=A->
			%iterate Y
			(Y<B->
				NewY is Y+1,
				(wall(X,NewY)->true;wallBetween(X,NewY,A,B))
				;
				NewY is Y-1,
				(wall(X,NewY)->true;wallBetween(X,NewY,A,B))
			)
			;
			%iterate X
			(X<A->
				NewX is X+1,
				(wall(NewX,Y)->true;wallBetween(NewX,Y,A,B))
				;
				NewX is X-1,
				(wall(NewX,Y)->true;wallBetween(NewX,Y,A,B))
			)
		)
	).



inc(X,X1) :-
	X1 is X+1.

dec(X,X1) :-
	X1 is X-1.
	
main :-

	% get info from the info module
	mazeInfo:info(_,_,Type),
	mazeInfo:start(X,Y),

	%Stream is the output file to write to  
    open('path-solution.txt',write, Stream),

	
	% if statement syntax
	( isA(Type) -> simulateA(X,Y,Stream) ; simulateC(X,Y,1,Stream) ),
	
	write("end").

simulateA(StartX, StartY,Stream) :- 
	mazeInfo:goal(GoalX,GoalY),
	write(Stream,"["),write(Stream,StartX),write(Stream,","),write(Stream,StartY),write(Stream,"]"),write(Stream,"\n"),

	(StartX =:= GoalX,StartY =:= GoalY -> halt();write("")),

	( StartX < GoalX -> 
		inc(StartX,NewStartX),
		simulateA(NewStartX,StartY,Stream)
		;

		(StartX > GoalX ->
			dec(StartX,NewStartX),
			simulateA(NewStartX,StartY,Stream)
			;

			(StartY < GoalY ->
				inc(StartY,NewStartY),
				simulateA(StartX,NewStartY,Stream)
				;

				(StartY > GoalY ->
					dec(StartY,NewStartY),
					simulateA(StartX,NewStartY,Stream)
					;

					write("Shouldnt be here"),nl
					)

				)
			)
		).

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
	write("In find path at "),write(StartX),write(","),write(StartY), nl,
	
	(equal(StartX,EndX),equal(StartY,EndY),FindingGoal -> printLastPath(StartX,StartY,Path,Stream) ; write("")),
	(equal(StartX,EndX),equal(StartY,EndY) -> printPath(StartX,StartY,ButtonNum,Path,Stream) ; write("")),
	write(FindingGoal),nl,
	inc(StartX,StartXPlusOne),
	inc(StartY,StartYPlusOne),
	dec(StartX,StartXMinusOne),
	dec(StartY,StartYMinusOne),


	append(Path,[[StartX,StartY]],NewPath),
	
	%down
	%right
	%up
	%left

	( isValid(StartX,StartYPlusOne,LastX,LastY,Path,ButtonNum) -> findPath(StartX,StartYPlusOne, EndX,EndY,NewPath,StartX,StartY,ButtonNum,FindingGoal,Stream);write("")),
	( isValid(StartXPlusOne,StartY,LastX,LastY,Path,ButtonNum) -> findPath(StartXPlusOne,StartY, EndX,EndY,NewPath,StartX,StartY,ButtonNum,FindingGoal,Stream);write("")),
	( isValid(StartX,StartYMinusOne,LastX,LastY,Path,ButtonNum) -> findPath(StartX,StartYMinusOne, EndX,EndY,NewPath,StartX,StartY,ButtonNum,FindingGoal,Stream);write("")),
	( isValid(StartXMinusOne,StartY,LastX,LastY,Path,ButtonNum) -> findPath(StartXMinusOne,StartY, EndX,EndY,NewPath,StartX,StartY,ButtonNum,FindingGoal,Stream);write("")),
	
	write("Backtrack"),nl.

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
	write("Terminating Program"),nl,
	% Terminate Program
	close(Stream),
	halt().

getStartCors(X,Y):-
	mazeInfo:start(X,Y).

getButtonCors(X,Y):-
	(mazeInfo:button(X,Y,_)->true;false).
