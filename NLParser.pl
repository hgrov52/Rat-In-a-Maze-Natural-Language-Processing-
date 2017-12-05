:- module('NLParser',[main/0]).

main :-
	%open the file to parse
    open('NL-input.txt', read, Str),

    %Stream is the output file to write to  
    open('NL-parse-solution.txt',write, Stream),

    %parse the file
    read_file(Str,Lines),

    %Convert the lines in file to an list of sentences that are lists of words
    lines_to_words(Lines, Words),


    
    parseParagraph(Words),
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

parseParagraph([]).
parseParagraph(Para):-
    Para = [Sentence|Tail],
    write(Sentence),nl,
    parseSentence(Sentence),nl,
    parseParagraph(Tail).

makeTrue(true).
makeFalse(false).
not(X):-
    (X->false;true).

parseSentence([]).
parseSentence(X):-
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
                            (not(SixWords)->write("Too many words")
                                ;
                                write("Valid Sentence"),
                                interpretValidSentence(X)
                            );
                            % Five is not a directoion, invalid sentence
                            write("No Direction")
                        );
                        % Four is not a Directional Object so invalid sentence
                        write("No Directional Object")
                    );
                    % Three was not a number so it must be in listVerbArticles
                    (member(Three,VA)->
                        %Four must be in listVerbSingleObjects
                        (member(Four,VO)->
                            % valid as long as no word follows
                            (not(FiveWords)->write("Too many words")
                                ;
                                write("Valid Sentence"),
                                interpretValidSentence(X)
                            )
                        );
                        % Not a valid sentence
                        write("No Verb Article")
                    )
                )

                % ==========
                ;
                % Two is not a verb so not a valid sentence
                %makeFalse(Valid4)
                write("No Verb")
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
                                    (not(Empty)->write("10")
                                        ;
                                        write("Valid Sentence"),
                                        interpretValidSentence(X)
                                    );
                                    % Six is not a directoion, invalid sentence
                                    write("No Direction")
                                );
                                % Five is not a Directional Object so invalid sentence
                                write("No Directional Object")
                            );
                            % Four was not a number so it must be in listVerbArticles
                            (member(Four,VA)->
                                %Five must be in listVerbSingleObjects
                                (member(Five,VO)->
                                    % valid as long as no word follows
                                    (not(Empty)->write("13")
                                        ;
                                        write("Valid Sentence"),
                                        interpretValidSentence(X)
                                    )
                                );
                                % Not a valid sentence
                                write("No Verb Article")
                            )
                        )

                        % ========
                        ;
                        % Three is not a verb so not a valid sentence
                        %makeFalse(Valid5)
                        write("No Verb")
                    );
                    % Two isnt a subject so not a valid sentence
                    %makeFalse(Valid3)
                    write("No Subject")
                );
                % One isnt a subject or article so not a valid sentence
                %makeFalse(Valid2)
                write("No Subject or Article")
            )
        )
    ;write("Not a Valid Sentence")),
    write(""),nl.

% can he push a button if theres no button where hes standing?
interpretValidSentence([]).
interpretValidSentence(Sent):-
    %(member("button")->)
    write("").
    



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