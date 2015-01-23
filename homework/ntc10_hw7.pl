swap([X], [X]).
swap([], []).
swap(A, B) :-
    append([First | Mid], [Last], A),
    append([Last | Mid], [First], B).


distance1([],[], 0).
distance1([H1|L1], [H2|L2], X):- 
  Y is (H1-H2)*(H1-H2), 
  distance1(L1, L2, Z), 
  X is Y+Z.
distance(V1, V2, D):-
  distance1(V1, V2, D1),
    D is sqrt(D1).


modify(0, X, [_|T], [X|T]).
modify(I, X, [H|T], [H|R]):-
  I > 0,
  I1 is I-1,
  modify(I1, X, T, R).