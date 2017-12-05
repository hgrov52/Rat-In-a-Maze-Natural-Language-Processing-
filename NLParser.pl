:- module('NLParser',[main/0]).
:- use_module(mazeSolver,[getStartCors/2,isValidNL/4]).


main :-
	%open the file to parse
    open('NL-input.txt', read, Str),

    %Stream is the output file to write to  
    open('NL-parse-solution.txt',write, Stream),

    %parse the file
    read_file(Str,Lines),

    %Convert the lines in file to an list of sentences that are lists of words
    lines_to_words(Lines, Words),


    mazeSolver:getStartCors(X,Y),
    parseParagraph(Words,X,Y,Stream),
    %catch(tester(Words),error(E,C),(writeln(E:C),false)),


    close(Stream),
    %close the parsing file
    close(Str),

    write("").

    
tester([]).
tester([H|T]):-
    fail,

    write("").
% Words that are not in the examples should make the 
% sentence invalid becuase they are not in the vocabulary.
writeThis(X):-
    write(X).

list_empty([], true).
list_empty([_|_], false).


listSubjectPhraseArticles(["the","a"]).
listSubjectPhraseSubjects(["rat","it","he","rodent","einstein"]).
listVerbPhraseVerbs(["ran","moved","pushed","scurried"]).
listNumbers(["1","2","3","4","5","6","7","8","9"]).
listDirections(["up","down","left","right"]).
listVerbArticles(["the"]).
listVerbDirectionalObjects(["cells","cell","squares","square"]).
listVerbSingleObjects(["button"]).

parseParagraph([],_,_,_).
parseParagraph(Para,StartX,StartY,Stream):-
    Para = [Sentence|Tail],
    parseSentence(Sentence,StartX,StartY,NewX,NewY,Stream),nl,

    


    parseParagraph(Tail,NewX,NewY,Stream).

makeTrue(true).
makeFalse(false).
not(X):-
    (X->false;true).

parseSentence([],_,_,_).
parseSentence(X,StartX,StartY,NewX,NewY,Stream):-
    length(X,ListLength),
    (ListLength>3,ListLength<7 ->
        X     = [One|Temp1],
        Temp1 = [Two|Temp2],
        Temp2 = [Three|Temp3],
        Temp3 = [Four|Temp4],
        list_empty(Temp4,FiveWords),
        (FiveWords->write("");Temp4 = [Five|Temp5]),
        list_empty(Temp5,SixWords),
        (SixWords->write("");Temp5 = [Six|Rest]),

        % Not a Valid sentence if Empty is not true
        list_empty(Rest,Empty),

        % One can be in listSubjectPhraseSubjects or 
        % One can be in listSubjectPhraseArticles but 
        % Two then has to be in listSubjectPhraseSubjects
        listSubjectPhraseSubjects(LSS),
        listVerbPhraseVerbs(VV),
        listSubjectPhraseArticles(LSA),
        listNumbers(N),
        listVerbDirectionalObjects(VDO),
        listVerbArticles(VA),
        listVerbSingleObjects(VO),
        listDirections(D),

        % One is a subject
        (member(One,LSS)->
            % Two must be a verb
            (member(Two,VV)->
                % ========== After Verb

                % Three is a number or an article 
                (member(Three,N)->
                    % Three was a number
                    % Four must be in listVerbDirectionalObjects
                    (member(Four,VDO)->
                        % Five must be a Direction
                        (member(Five,D)->
                            (not(SixWords)->format(Stream,"Not a valid sentence~n",[])
                                ;
                                %write(Stream,"Valid Sentence"),
                                interpretValidSentence(X,StartX,StartY,NewX,NewY,Stream)
                            );
                            % Five is not a directoion, invalid sentence
                            %write("No Direction")
                            format(Stream,"Not a valid sentence~n",[])
                        );
                        % Four is not a Directional Object so invalid sentence
                        %write("No Directional Object")
                        format(Stream,"Not a valid sentence~n",[])
                    );
                    % Three was not a number so it must be in listVerbArticles
                    (member(Three,VA)->
                        %Four must be in listVerbSingleObjects
                        (member(Four,VO)->
                            % valid as long as no word follows
                            (not(FiveWords)->format(Stream,"Not a valid sentence~n",[])
                                ;
                                %write(Stream,"Valid Sentence"),
                                interpretValidSentence(X,StartX,StartY,NewX,NewY,Stream)
                            )
                        );
                        % Not a valid sentence
                        %write("No Verb Article")
                        format(Stream,"Not a valid sentence~n",[])
                    )
                )

                % ==========
                ;
                % Two is not a verb so not a valid sentence
                %makeFalse(Valid4)
                %write("No Verb")
                format(Stream,"Not a valid sentence~n",[])
            );
            % One is not a subject, so must be an listSubjectPhraseArticles
            (member(One,LSA)->
                % Two must be in listSubjectPhraseSubjects
                (member(Two,LSS)->
                    % Three must be a verb
                    (member(Three,VV)->
                        % ======== After Verb


                        % Four is a number or an article 
                        (member(Four,N)->
                            % Four was a number
                            % Five must be in listVerbDirectionalObjects
                            (member(Five,VDO)->
                                % Six must be a Direction
                                (member(Six,D)->
                                    (not(Empty)->write("")
                                        ;
                                        %write(Stream,"Valid Sentence"),
                                        interpretValidSentence(X,StartX,StartY,NewX,NewY,Stream)
                                    );
                                    % Six is not a directoion, invalid sentence
                                    %write("No Direction")
                                    write("Not a valid sentence")
                                );
                                % Five is not a Directional Object so invalid sentence
                                %write("No Directional Object")
                                format(Stream,"Not a valid sentence~n",[])
                            );
                            % Four was not a number so it must be in listVerbArticles
                            (member(Four,VA)->
                                %Five must be in listVerbSingleObjects
                                (member(Five,VO)->
                                    % valid as long as no word follows
                                    (not(Empty)->
                                        %write("Too many words")
                                        format(Stream,"Not a valid sentence~n",[])
                                        ;
                                        %write("Valid Sentence"),
                                        interpretValidSentence(X,StartX,StartY,NewX,NewY,Stream)
                                    )
                                );
                                % Not a valid sentence
                                %write("No Verb Article")
                                format(Stream,"Not a valid sentence~n",[])
                            )
                        )

                        % ========
                        ;
                        % Three is not a verb so not a valid sentence
                        %makeFalse(Valid5)
                        %write("No Verb")
                        format(Stream,"Not a valid sentence~n",[])
                    );
                    % Two isnt a subject so not a valid sentence
                    %makeFalse(Valid3)
                    %write("No Subject")
                    format(Stream,"Not a valid sentence~n",[])
                );
                % One isnt a subject or article so not a valid sentence
                %makeFalse(Valid2)
                %write("No Subject or Article")
                format(Stream,"Not a valid sentence~n",[])
            )
        )
    ;format(Stream,"Not a valid sentence~n",[])),
    write("").

% can he push a button if theres no button where hes standing?


interpretValidSentence([],_,_,_).
interpretValidSentence(Sent,StartX,StartY,NewX,NewY,Stream):-
    
    (member("button",Sent)-> pushButton(StartX,StartY,Stream),
        NewX is StartX,NewY is StartY
        ;
        % moving rat to diff location
        findNumber(Sent,Num),
        findNewCoordinates(Sent,StartX,StartY,NewX,NewY,Num),
        format("Move from ~w,~w to ~w,~w~n",[StartX,StartY,EndX,EndY]),
        (mazeSolver:isValidNL(StartX,StartY,EndX,EndY)->
            format(Stream,"Valid move~n",[]),
            format("Valid move, changing coordinates to ~w,~w",[EndX,EndY]),
            NewX is EndX,NewY is EndY
            ;
            format(Stream,"Not a valid move~n",[]),
            write("Not a valid move"),
            NewX is StartX,NewY is StartY
        )    
    ).

    
pushButton(X,Y,Stream):-
    format("Push button at ~w,~w",[X,Y]).


findNumber([H|T],Num):-
    (number_string(Num,H)->write("");findNumber(T,Num)).


dirUp("up").
dirDown("down").
dirRight("right").
dirLeft("left").
findNewCoordinates([],_,_,_).
findNewCoordinates([H|T],X,Y,NewX,NewY,Num):-
    (dirUp(H)->NewY is Y-Num,NewX is X
        ;
        (dirDown(H)->NewY is Y+Num, NewX is X
            ;
            (dirRight(H)->NewX is X+Num,NewY is Y
                ;
                (dirLeft(H)->NewX is X-Num,NewY is Y
                    ;
                    findNewCoordinates(T,X,Y,NewX,NewY,Num)
                )
            )
        )    
    ).


% Credit to StackOverflow and author Ishq for file parser
% https://stackoverflow.com/a/4805931
% https://stackoverflow.com/users/577045/ishq
read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).

%Converts sentence to a list of words
lines_to_words([], []).
lines_to_words([H|T], [H2|T2]) :-
	split_string(H, " ", "", H2),
	lines_to_words(T, T2).