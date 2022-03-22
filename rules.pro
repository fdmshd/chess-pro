opponent(white,black).
opponent(black,white).

can_move(PlayerC,piece(Color, Name, X, Y), Board, X1, Y1):-
    PlayerC = Color,
    vacant(Color,X1,Y1,Board),
    member(piece(Color,Name,X,Y),Board),
    canPieceMoveTo(piece(Color,Name,X,Y),Board, X1,Y1).

vacant(Color,X, Y, Board):- 
    between(1, 8, Y),
    between(1, 8, X),
    not(member(piece(Color, _, X, Y), Board)).

%TODO:проверить не связана ли фигура
%check_pin(piece(Color,Name,X,Y), X1,Y1):- .

%проверить случился ли шах
check_check(Board,PlayerColor):- 
    member(piece(PlayerColor, king, X,Y),Board),
    opponent(PlayerColor,OpponentColor),
    can_move(PlayerColor,piece(OpponentColor,_,_,_),Board,X,Y).

%TODO: Для ферзя добавить проверку не стоит ли на проходе другая фигура
%TODO: Для пешки логику боя на проходе задать
%TODO: Для пешки логику первого хода задать(на два поля вперед)
%TODO: Изменить все ABS (как в коне)

%TODO: Добавить предикат проверки наличия фигур между двумя полями
% \/ - Это он внизу(Для слонов, уверен, что не работает)

pieceBetween(X,Y,X,Y,_).

pieceBetween(X,Y,X1,Y1, Board):-
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
    not(member(piece(_,_,Z,Y),Board)),!.

%rules for knight
canPieceMoveTo(piece(_, knight, X, Y),_, X1, Y1):-
    Ax is abs(X - X1), Ax = 2, Ay is abs(Y - Y1), Ay = 1.
canPieceMoveTo(piece(_, knight, X, Y),_, X1, Y1):-
    Ax is abs(X - X1), Ax= 1, Ay is abs(Y - Y1), Ay = 2.

%rules for bishop
canPieceMoveTo(piece(_, bishop, X, Y),Board, X1, Y1):-
    Ax is abs(X - X1),
    Ay is abs(Y - Y1),
    Ax=Ay,
    pieceBetween(X,Y,X1,Y1, Board).

%rules for queen
canPieceMoveTo(piece(_, queen, X, Y),Board, X1, Y1):-
    Ax is abs(X - X1),
    Ay is abs(Y - Y1),
    Ax=Ay,
    pieceBetween(X,Y,X1,Y1,Board).
canPieceMoveTo(piece(_, queen, X, Y),Board, X1, Y1):-
    X = X1,
    between(Y,Y1,Z),
    not(member(piece(_,_,X,Z),Board)),!.
    
canPieceMoveTo(piece(_, queen, X ,Y),Board, X1, Y1):-
    Y = Y1,
    between(X,X1,Z),
    not(member(piece(_,_,Z,Y),Board)),!.
    

%rules for pawn
canPieceMoveTo(piece(white, pawn, X, 2),Board, X1, Y1):-
    X = X1, Y1 = 4,
    not(member(piece(black, _, X1, Y1), Board)).

canPieceMoveTo(piece(white, pawn, X, Y),Board, X1, Y1):-
    X = X1, Y1 - Y = 1,
    not(member(piece(black, _, X1, Y1), Board)).

canPieceMoveTo(piece(black, pawn, X, Y),Board, X1, Y1):-
    X = X1, Y - Y1 = 1,
    not(member(piece(white, _, X1, Y1), Board)).

canPieceMoveTo(piece(black, pawn, X, 7),Board, X1, Y1):-
    not(member(piece(white, _, X1, Y1), Board)),
    X = X1, Y1 = 5.

canPieceMoveTo(piece(Color, pawn, _, _),Board, X1, Y1):-
    opponent(Color,OppColor),
    not(member(piece(OppColor, _, X1, Y1), Board)),member(piece(_,_,X1,Y1),Board).

%rules for king
canPieceMoveTo(piece(Color,king,X,Y),Board,X1,Y1):-
    opponent(Color,OppColor),
    not(can_move(OppColor,piece(OppColor,_,_,_),Board,X1,Y1)),
    Ax is abs(X-X1),
    Ax=<1,
    Ay is abs(Y-Y1),
    Ay=<1.

