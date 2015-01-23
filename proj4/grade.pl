menu(X) :- 
   write('\tClass roster management system'), nl,
   write('\t=============================='), nl,
   write('\t   MENU'), nl,
   write('\t=============================='), nl,
   write('\t0. Reset Roster'), nl,
   write('\t1. Load roster from a file'), nl,
   write('\t2. Store roster to a file'), nl,
   write('\t3. Display roster sorted by ID'), nl,
   write('\t4. Display roster sorted by name'), nl,
   write('\t5. Display roster sorted by grade'), nl,
   write('\t6. Display student info'), nl,
   write('\t7. Add a student to roster'), nl,
   write('\t8. Remove a student from roster'), nl,
   write('\t9. Exit'), nl, 
   write('\tEnter your choice (followed by a \'.\'): '),
   read(Sel),
   process(Sel, X).

process(0, _) :-
    write('\tRoster reset (now empty).'),
    nl, nl, menu([]).

process(1, _) :-
    nl,
    write('\tRead roster from a file:'),nl,
    write('\tEnter file name: '),
    read(A),
    open(A, read, F),
    read(F, Z),
    close(F),
    write('\tRoster read from file'),
    nl, nl, menu(Z).

process(2, X) :-
    nl,
    write('\tStore roster to a file:'),nl,
    write('\tEnter file name: '),
    read(A),
    open(A, write, F),
    write(F, X),
    write(F, '.'),
    close(F),
    write('\tRoster stored'),
    nl, nl, menu(X).

process(3, X) :-
    nl,
    write('\tDisplay Roster, sort by ID:'),nl,nl,
    sort(X, Z),
    show_records(Z),
    nl, nl, menu(X).

process(4, X) :-
    nl,
    write('\tDisplay Roster, sort by name:'),nl,nl,
    sort_by_name(X, Z),
    show_records(Z),
    nl, nl, menu(X).

process(5, X) :-
    nl,
    write('\tDisplay Roster, sort by grade:'),nl,nl,
    sort_by_grade(X, Z),
    show_records(Z),
    nl, nl, menu(X).

process(6, X) :- 
    nl,
    write('\tDisplay student information:'),nl,nl,
    write('\tEnter student name or ID : '),
    read_name_id(A),
    
    (in_list_disp([A, A, _], X) ->
      nl, nl, menu(X)
    ; string_to_atom(A, D),
      format('\tStudent (ID:~a) is not in the roster', D), nl, nl, menu(X)
    ).

process(7, X) :- 
    nl,
    write('\tAdd a student to the class roster'),nl,
    read_student_info([A, B, C]),
    (in_list([A, B, C], X) ->
      string_to_atom(A, D),
      format('\tStudent (ID:~a) is already on the roster', D),
      nl, nl, menu(X)
    ; string_to_atom(A, D),
      format('\tStudent (ID:~a) inserted.', D),
      nl, nl, menu([[A, B, C] | X])
    ).

process(8, X) :- 
    nl,
    write('\tRemove a student from roster:'),nl,
    write('\tEnter student name or ID : '),
    read_name_id(A),
    
    (in_list_name([A, A, _], X) ->
      (select([A, _, _], X, Z); select([_, A, _], X, Z)),
      string_to_atom(A, D),
      format('\tStudent ~a removed', D), 
      nl, nl, menu(Z)
    ; string_to_atom(A, D),
      format('\tStudent ~a is not in the roster', D), nl, nl, menu(X)
    ).

process(9, _) :- write('Good-bye'), nl, !.
process(_, X) :- menu(X).

read_student_info([A, B, C]) :-
  write('\tStudent ID: '),
  read(A),
  write('\tStudent Name: '),
  read(B),
  write('\tStudent Grade: '),
  read(C).

read_name_id(A) :-
  read(A).

show_records(L) :-
  length(L, I),
  (I > 0 ->  
    forall(nth1(N, L, E), format('\tNo.~d:ID="~s", Name="~s", Grade=~a~n', [N|E]))
  ; write('\tThe class roster is empty')
  ).

disp_student(L) :-
  forall(nth1(N, L, E), format('\tNo.~d:ID="~s", Name="~s", Grade=~a~n', [N|E])).

in_list([A, _, _], [[H1, _, _]|_]) :- A == H1, !.

in_list([A, _, _], [_|T]) :-
  in_list([A, _, _], T).

in_list_name([A, B, _], [[H1, H2, _]|_]) :- (A == H1; B == H2), !.

in_list_name([A, B, _], [_|T]) :-
  in_list_name([A, B, _], T).

in_list_disp([A, B, _], [[H1, H2, H3]|_]) :-
  (A == H1; B == H2),
  format('\tID="~s", Name="~s", Grade=~a~n', [H1, H2, H3]),
  !.

in_list_disp([A, B, _], [_|T]) :-
  in_list_disp([A, B, _], T).

sort_by_name(X, Z) :-
    predsort(compare_name, X, Z).

compare_name(R, [_,X2,_], [_,Y2,_]) :-
    ( X2 == Y2
      ; compare(R, X2, Y2)
    ).

sort_by_grade(X, Z) :-
    predsort(compare_grade, X, Z).

compare_grade(R, [_,_,X3], [_,_,Y3]) :-
    ( X3 == Y3
      ; compare(R, X3, Y3)
    ).