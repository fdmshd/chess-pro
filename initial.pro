initial(piece(white,rook, 1, 1)).
initial(piece(white,knight,2,1)).
initial(piece(white,bishop,3,1)).
initial(piece(white,queen,4,1)).
initial(piece(white,king,5,1)).
initial(piece(white,bishop,6,1)).
initial(piece(white,knight,7,1)).
initial(piece(white,rook,8,1)).
initial(piece(white,pawn,X,2)):- between(1, 8, X).


initial(piece(black,rook, 1, 8)).
initial(piece(black,knight,2,8)).
initial(piece(black,bishop,3,8)).
initial(piece(black,queen,4,8)).
initial(piece(black,king,5,8)).
initial(piece(black,bishop,6,8)).
initial(piece(black,knight,7,8)).
initial(piece(black,rook,8,8)).
initial(piece(black,pawn,X,7)):- between(1, 8, X).
