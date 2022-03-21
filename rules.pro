move(Player,piece(Color, Name, X, Y), Board, X1, Y1):-
    Player = Color,
    vacant(Color,X1,Y1,Board),
    canPieceMoveTo(piece(Color,Name,X,Y),Board, X1,Y1).

vacant(Color,X, Y, Board):- 
    between(1, 8, Y),
    between(1, 8, X),
    not(member(piece(Color, _, X, Y), Board)).

%проверить не связана ли фигура
check_pin(piece(Color,Name,X,Y), X1,Y1).
%Проверить защищает ли этот ход от шаха(если он случился).
check_check().

%TODO: Для ферзя добавить проверку не стоит ли на проходе другая фигура
%TODO: Для пешки логику боя на проходе задать

%TODO: Добавить предикат проверки наличия фигур между двумя полями
% \/ - Это он внизу(Для слонов, не уверен, что работает)
pieceBetween(X,Y,X1,Y1, Board):-
    abs(X-X1)>1,
    abs(Y-Y1)>1,
    member(piece(_,_,X+1,Y+1),Board),!,
    pieceBetween(X+1,Y+1,X1,Y1, Board).

%rules for rook
canPieceMoveTo(piece(_, rook, X, Y),Board, X1, Y1):-
    X = X1,
    between(Y,Y1,Z),
    not(member(piece(_,_,X,Z),Board)),!.
    
canPieceMoveTo(piece(_, rook, X, Y),Board, X1, Y1):-
    Y = Y1,
    between(X,X1,Z),
    not(member(piece(_,_,X,Z),Board)),!.

%rules for knight
canPieceMoveTo(piece(_, knight, X, Y),Board, X1, Y1):-
    abs(X - X1) = 2, abs(Y - Y1) = 1.
canPieceMoveTo(piece(_, knight, X, Y),Board, X1, Y1):-
    abs(X - X1) = 1, abs(Y - Y1) = 2.

%rules for bishop
canPieceMoveTo(piece(_, bishop, X, Y),Board, X1, Y1):-
    abs(X - X1) = abs(Y - Y1),
    pieceBetween(X,Y,X1,Y1, Board).

%rules for queen
canPieceMoveTo(piece(_, queen, X, Y),Board, X1, Y1):-
    abs(X - X1) = abs(Y - Y1).
canPieceMoveTo(piece(_, queen, X, Y),Board, X1, Y1):-
    X = X1.
    
canPieceMoveTo(piece(_, queen, X ,Y),Board, X1, Y1):-
    Y = Y1,
    between(X,X1,Z),
    not(member(piece(_,_,X,Z),Board)),!.
    

%rules for pawn
canPieceMoveTo(piece(white, pawn, X, Y),Board, X1, Y1):-
    X = X1, Y1 - Y = 1.
canPieceMoveTo(piece(black, pawn, X, Y),Board, X1, Y1):-
    X = X1, Y - Y1 = 1.
canPieceMoveTo(piece(Color, pawn, X, Y),Board, X1, Y1):-
    not(member(piece(Color, _, X1, Y1), Board)),member(piece(_,_,X1,Y1),Board).

%rules for king
canPieceMoveTo(piece(white,king,X,Y),Board,X1,Y1):-
    not(canPieceMoveTo(piece(black,_,_,_),Board,X1,Y1)),
    abs(X-X1)=1.
canPieceMoveTo(piece(white,king,X,Y),Board,X1,Y1):-
    not(canPieceMoveTo(piece(black,_,_,_),Board,X1,Y1)),
    abs(Y-Y1)=1.

canPieceMoveTo(piece(black,king,X,Y),Board,X1,Y1):-
    not(canPieceMoveTo(piece(white,_,_,_),Board,X1,Y1)),
    abs(X-X1)=1.
canPieceMoveTo(piece(black,king,X,Y),Board,X1,Y1):-
    not(canPieceMoveTo(piece(white,_,_,_),Board,X1,Y1)),
    abs(Y-Y1)=1.