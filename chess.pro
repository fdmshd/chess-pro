?-['initial.pro'].
?-['rules.pro'].
initialize_board():-
    findall(Piece, initial(Piece), Board),
    draw_board(Board),
    play(Board,white).

play(Board, Color):-
  write("Введите имя фигуры :"),
  read(Name),
  write("Введите координату X фигуры :"),
  read(X),
  write("Введите координату Y фигуры :"),
  read(Y),
  write("Введите новую координату X фигуры :"),
  read(X1),
  write("Введите новую координату Y фигуры :"),
  read(Y1),
  do_move(Color,piece(Color, Name,X,Y),Board,X1,Y1,NewBoard),
  draw_board(NewBoard),
  opponent(Color,OppColor),
  play(NewBoard,OppColor).

do_move(PlayerC,piece(Color, Name, X, Y), Board, X1, Y1, NewBoard):-
  can_move(PlayerC,piece(Color, Name, X, Y), Board, X1, Y1),
  delete(Board,piece(Color, Name, X, Y),  PreBoard),
  delete(PreBoard,piece(_,_, X1,Y1), PreBoard1 ),
  append(PreBoard1,[piece(Color, Name, X1, Y1)],NewBoard).
  


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
  ( member(piece(_, Which, X, Y), Board) ->
    letter(Which, Letter),
    write(Letter)
    ;
    write('_')
  ).
letter(rook,r).
letter(knight,h).
letter(bishop,b).
letter(queen,q).
letter(king,k).
letter(pawn,p).
