?-['initial.pro'].
?-['rules.pro'].
initialize_board():-
    findall(Piece, initial(Piece), Board),
    draw_board(Board),
    play(Board,white).

read_move(Name,X,Y,X1,Y1):-
  write("Введите ход в формате 'hg1f3': "),
  read(M),
  atom_chars(M,[Pname,Px,Py,Px1,Py1]),
  letter(Name,Pname),
  atom_int(Py,Y),
  atom_int(Py1,Y1),
  coord(Px,X),
  coord(Px1,X1).

play(Board, Color):-
  repeat,
  read_move(Name,X,Y,X1,Y1),
  can_move(Color,piece(Color, Name, X, Y), Board, X1, Y1),
  do_move(piece(Color, Name,X,Y),Board,X1,Y1,PreNewBoard),
  delete(PreNewBoard,last_move(piece(_, _, _, _),_,_),  PreBoard),
  append(PreBoard, [last_move(piece(Color, Name, X,Y), X1,Y1)], NewBoard),
  draw_board(NewBoard),
  opponent(Color,OppColor),
  (check_check(NewBoard,OppColor)->play(NewBoard,OppColor)
  ;writeln("Шах!!!"),
  check_checkmate(NewBoard,OppColor)->
  play(NewBoard, OppColor);
  writeln("И мат!!!")
  ).

promotion(NewPiece):-
  repeat,
  writeln("Введите новую фигуру(queen;knight;rook;bishop): "),
  read(NewPiece),
  (NewPiece = queen;NewPiece = knight;NewPiece = rook;NewPiece = bishop).


%Условия для провода пешки (белой)
do_move(piece(white,pawn,X,7),Board,X1,8,NewBoard):-
  delete(Board,piece(black, _, X1, 8),  PreBoard),
  delete(PreBoard,piece(white, pawn, X, 7),  PreBoard1),
  promotion(NewPiece),
  append(PreBoard1,[piece(white, NewPiece, X1, 8)],NewBoard),!.

%Условия для провода пешки (черной)
do_move(piece(black,pawn,X,2),Board,X1,1,NewBoard):-
  delete(Board,piece(white, _, X1, 1),  PreBoard),
  delete(PreBoard,piece(black, pawn, X, 2),  PreBoard1),
  promotion(NewPiece),
  append(PreBoard1,[piece(white, NewPiece, X1, 1)],NewBoard),!.

%Условия для боя на проходе
do_move(piece(white,pawn,X,5), Board,X1,6, NewBoard):-
  member(last_move(piece(black,pawn, X1, 7),X1, 5),Board),
  delete(Board,piece(white, pawn, X, 5),  PreBoard),
  delete(PreBoard,piece(black, pawn, X1, 5),  PreBoard1),
  append(PreBoard1,[piece(white, pawn, X1, 6)],NewBoard),!.

do_move(piece(black,pawn,X,4), Board,X1,3, NewBoard):-
  member(last_move(piece(white,pawn, X1, 2),X1, 4),Board),
  delete(Board,piece(black, pawn, X, 4),  PreBoard),
  delete(PreBoard,piece(white, pawn, X1, 4),  PreBoard1),
  append(PreBoard1,[piece(black, pawn, X1, 3)],NewBoard),!.

%Условия для длинной рокировки
do_move(piece(Color,king,4,Y), Board,6,Y, NewBoard):-
  delete(Board,piece(Color, king, 4, Y),  PreBoard),
  delete(PreBoard,piece(Color,rook, 8,Y), PreBoard1 ),
  append(PreBoard1,[piece(Color, rook, 5, Y)],PreBoard2),
  append(PreBoard2,[piece(Color, king, 6, Y)],NewBoard),!.

%Условия для короткой рокировки
do_move(piece(Color,king,4,Y), Board,2,Y, NewBoard):-
  delete(Board,piece(Color, king, 4, Y),  PreBoard),
  delete(PreBoard,piece(Color,rook, 1,Y), PreBoard1 ),
  append(PreBoard1,[piece(Color, rook, 3, Y)],PreBoard2),
  append(PreBoard2,[piece(Color, king, 2, Y)],NewBoard),!.

%Запомнить, что ладья уже ходила
do_move(piece(Color, rook, X, Y), Board, X1, Y1, NewBoard):-
  delete(Board, already_moved(piece(Color,rook,X,Y)),Board1),
  append(Board1,[already_moved(piece(Color, rook, X1, Y1))],Board2),
  delete(Board2,piece(Color, rook, X, Y),  PreBoard),
  delete(PreBoard,piece(_,_, X1,Y1), PreBoard1 ),
  append(PreBoard1,[piece(Color, rook, X1, Y1)],NewBoard),!.

%Запомнить, что король уже ходил
do_move(piece(Color, king, X, Y), Board, X1, Y1, NewBoard):-
  delete(Board, already_moved(piece(Color,king,X,Y)),Board1),
  append(Board1,[already_moved(piece(Color, king, X1, Y1))],Board2),
  delete(Board2,piece(Color, king, X, Y),  PreBoard),
  delete(PreBoard,piece(_,_, X1,Y1), PreBoard1 ),
  append(PreBoard1,[piece(Color, king, X1, Y1)],NewBoard),!.

%Условия для обычного хода
do_move(piece(Color, Name, X, Y), Board, X1, Y1, NewBoard):-
  delete(Board,piece(Color, Name, X, Y),  PreBoard),
  delete(PreBoard,piece(_,_, X1,Y1), PreBoard1 ),
  append(PreBoard1,[piece(Color, Name, X1, Y1)],NewBoard).



%Рисование доски и фигур
draw_board(Board) :-
    nl, draw_row(1, 1, Board), nl.
  
draw_row(X, Y, Board) :-
  X =< 8,
  draw_piece(X, Y, Board),
  X1 is X+1,
  draw_row(X1, Y, Board).
draw_row(9, Y, Board) :-
  Y =< 7,
  nl,
  Y1 is Y+1,
  draw_row(1, Y1, Board).
draw_row(9, 8, _) :-
  nl.
  
draw_piece(X, Y, Board) :-
  X == 1,
  write('    .'),
  draw_piece_on_board(X, Y, Board),
  write('.').
  
draw_piece(X, Y, Board) :-
  X > 1,
  draw_piece_on_board(X, Y, Board),
  write('.').
  
draw_piece_on_board(X, Y, Board) :-
  member(piece(white, Which, X, Y), Board),
  letter(Which, Letter),
  write(Letter).

draw_piece_on_board(X, Y, Board) :-
  ( member(piece(black, Which, X, Y), Board) ->
    letter(Which, Letter),
    ansi_format([bold,fg(black)],'~w', Letter)
    ;
    write('_')
  ).

letter(rook,r).
letter(knight,h).
letter(bishop,b).
letter(queen,q).
letter(king,k).
letter(pawn,p).
coord(h,1).
coord(g,2).
coord(f,3).
coord(e,4).
coord(d,5).
coord(c,6).
coord(b,7).
coord(a,8).
atom_int('1',1).
atom_int('2',2).
atom_int('3',3).
atom_int('4',4).
atom_int('5',5).
atom_int('6',6).
atom_int('7',7).
atom_int('8',8).