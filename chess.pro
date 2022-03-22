?-['initial.pro'].
?-['rules.pro'].
initialize_board():-
    findall(Piece, initial(Piece), Board),
    do_move(white, piece(white, knight,2, 1),Board, 3,3,NewBoard),
    draw_board(NewBoard).

do_move(PlayerC,piece(Color, Name, X, Y), Board, X1, Y1, NewBoard):-
  can_move(PlayerC,piece(Color, Name, X, Y), Board, X1, Y1),
  delete(Board,piece(Color, Name, X, Y),  PreBoard),
  append(PreBoard,[piece(Color, Name, X1, Y1)],NewBoard).
  


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
