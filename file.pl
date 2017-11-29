
takes(bob,ds).
reqs(ds,cs2).
reqs(cs2,cs1).
reqs(cs1,cs0).
has_taken(A,C) :- takes(A,B), reqs+(B,C).
reqs+(A,C) :- reqs(A,C).
reqs+(A,C) :- reqs(A,B), reqs+(B,C).