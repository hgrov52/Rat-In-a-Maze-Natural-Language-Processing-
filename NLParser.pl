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

    %close the parsing file
    close(Str),

    %write the output to the output file
    write(Stream,Words), nl,
    close(Stream),
    
    parseParagraph(Words),

    write("").

    


% Words that are not in the examples should make the 
% sentence invalid becuase they are not in the vocabulary.


list_empty([], true).
list_empty([_|_], false).

parseParagraph([]).
parseParagraph(Para):-
    Para = [Sentence|Tail],
    parseSentence(Sentence,[],[]),nl,
    parseParagraph(Tail).

parseSentence([]).
parseSentence(H|T,SubjectPhrase,VerbPhrase):-
    ListSubjectPhrases = ["the","a","rat","it","he","rodent","einstein"],
    Verbs = ["ran","moved","pushed","scurried","pushed","the","button","1","2","3","4","5","6","7","8","9","cells","cell","squares","up","down","left","right"],

    (member(H,ListSubjectPhrases) -> 
        append([H],SubjectPhrase,NewSubjectPhrase),
        parseSentence(T,NewSubjectPhrase,VerbPhrase);write("")),
    (member(H,ListVerbPhrases) ->
        append([H],VerbPhrase,NewVerbPhrase),
        parseSentence(T,NewSubjectPhrase,VerbPhrase);write("")),

    parseSubjectPhrase(SubjectPhrase),
    parseVerbPhrase(VerbPhrase).

parseSubjectPhrase(SubjectPhrase):-
    write(SubjectPhrase).

parseVerbPhrase(VerbPhrase):-
    write(VerbPhrase).
    




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