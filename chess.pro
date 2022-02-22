?-['initial.pro'].
initialize_board(Board):-
    findall(Piece, initial(Piece), Board).
    