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
    parse(Words),

    %close the output stream so that the text will show up
    close(Stream).

parseParagraph([]).
parseParagraph(Para):-
    Para = [Sentence|Tail],
    write(H),nl.
    parseParagraph(Tail).




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