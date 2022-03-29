opponent(white,black).
opponent(black,white).

can_move(PlayerC,piece(Color, Name, X, Y), Board, X1, Y1):-
    PlayerC = Color,
    vacant(Color,X1,Y1,Board),
    member(piece(Color,Name,X,Y),Board),
    canPieceMoveTo(piece(Color,Name,X,Y),Board, X1,Y1),
    premove(piece(Color,Name,X,Y), Board, X1,Y1,NewBoard),
    check_check(NewBoard, Color).

vacant(Color,X, Y, Board):- 
    between(1, 8, Y),
    between(1, 8, X),
    not(member(piece(Color, _, X, Y), Board)).

%Предикат для временного хода.
premove(piece(Color, Name, X, Y), Board, X1, Y1, NewBoard):-
    delete(Board,piece(Color, Name, X, Y),  PreBoard),
    delete(PreBoard,piece(_,_, X1,Y1), PreBoard1 ),
    append(PreBoard1,[piece(Color, Name, X1, Y1)],NewBoard).

%проверить не случится ли шах
check_check(Board,PlayerColor):- 
    member(piece(PlayerColor, king, X,Y),Board),
    opponent(PlayerColor,OpponentColor),
    not(piece_can_beat(piece(OpponentColor,_,_,_),Board,X,Y)).

%проверить есть ли защита от мата
check_checkmate(Board,Color):-
    member(piece(Color,Name,X,Y),Board),
    possible_moves(piece(Color,Name,X,Y),Board,X1,Y1),
    premove(piece(Color,Name,X,Y), Board, X1,Y1,NewBoard),
    check_check(NewBoard, Color).

% \/ - Предикаты для проверки хода по диагонали
check_diagonal(X,Y,X1,Y1,Board):-
    X1>X,
    Y1>Y,
    Xn is X+1,
    Yn is Y+1,
    pieceBetween(Xn,Yn,X1,Y1, Board).

check_diagonal(X,Y,X1,Y1,Board):-
    X1<X,
    Y1>Y,
    Xn is X-1,
    Yn is Y+1,
    pieceBetween(Xn,Yn,X1,Y1, Board).

check_diagonal(X,Y,X1,Y1,Board):-
    X1>X,
    Y1<Y,
    Xn is X+1,
    Yn is Y-1,
    pieceBetween(Xn,Yn,X1,Y1, Board).

check_diagonal(X,Y,X1,Y1,Board):-
    X1<X,
    Y1<Y,
    Xn is X-1,
    Yn is Y-1,
    pieceBetween(Xn,Yn,X1,Y1, Board).

pieceBetween(X,Y,X,Y,_):-!.
pieceBetween(X,Y,X1,Y1, Board):-
    X1>X,
    Y1>Y,
    not(member(piece(_,_,X,Y),Board)),!,
    Xn is X+1,
    Yn is Y+1,
    pieceBetween(Xn,Yn,X1,Y1, Board).

pieceBetween(X,Y,X1,Y1, Board):-
    X1<X,
    Y1>Y,
    not(member(piece(_,_,X,Y),Board)),!,
    Xn is X-1,
    Yn is Y+1,
    pieceBetween(Xn,Yn,X1,Y1, Board).

pieceBetween(X,Y,X1,Y1, Board):-
    X1>X,
    Y1<Y,
    not(member(piece(_,_,X,Y),Board)),!,
    Xn is X+1,
    Yn is Y-1,
    pieceBetween(Xn,Yn,X1,Y1, Board).

pieceBetween(X,Y,X1,Y1, Board):-
    X1<X,
    Y1<Y,
    not(member(piece(_,_,X,Y),Board)),!,
    Xn is X-1,
    Yn is Y-1,
    pieceBetween(Xn,Yn,X1,Y1, Board).

% Предикаты для проверки ходов по линиям (ладьи, ферзь)
check_l(X,Y,X1,Y1, Board):-
    X = X1,Y1>Y,
    Yn1 is Y1-1,
    Yn is Y +1,
    not(check_vertical1(X,Yn,X1,Yn1, Board)).

check_l(X,Y,X1,Y1, Board):-
    X = X1,Y1<Y,
    Yn1 is Y1 +1,
    Yn is Y - 1,
    not(check_vertical2(X,Yn,X1,Yn1, Board)).

check_l(X,Y,X1,Y1, Board):-
    Y = Y1, X1 > X,
    Xn1 is X1 -1,
    Xn is X +1,
    not(check_horizontal1(Xn,Y,Xn1,Y1, Board)).

check_l(X,Y,X1,Y1, Board):-
    Y = Y1, X1 < X,
    Xn1 is X1 +1,
    Xn is X - 1,
    not(check_horizontal2(Xn,Y,Xn1,Y1, Board)).

check_horizontal1(X,Y,X1,Y, Board):-
    between(X,X1,Z),
    member(piece(_,_,Z,Y),Board),!.

check_horizontal2(X,Y,X1,Y, Board):-
    between(X1,X,Z),
    member(piece(_,_,Z,Y),Board),!.

check_vertical1(X,Y,X,Y1, Board):-
    between(Y,Y1,Z),
    member(piece(_,_,X,Z),Board),!.

check_vertical2(X,Y,X,Y1, Board):-
    between(Y1,Y,Z),
    member(piece(_,_,X,Z),Board),!.

%rules for rook
canPieceMoveTo(piece(_, rook, X, Y),Board, X1, Y1):-
    check_l(X,Y,X1,Y1,Board).

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
    check_diagonal(X,Y,X1,Y1, Board).

%rules for queen
canPieceMoveTo(piece(_, queen, X, Y),Board, X1, Y1):-
    Ax is abs(X - X1),
    Ay is abs(Y - Y1),
    Ax=Ay,
    check_diagonal(X,Y,X1,Y1,Board),!.

canPieceMoveTo(piece(_, queen, X, Y),Board, X1, Y1):-
    check_l(X,Y,X1,Y1,Board).

%rules for pawn
canPieceMoveTo(piece(white, pawn, X, 2),Board, X1, Y1):-
    X = X1, Y1 = 4,
    not(member(piece(_, _, X1, 3), Board)),
    not(member(piece(_, _, X1, Y1), Board)).

canPieceMoveTo(piece(white, pawn, X, Y),Board, X1, Y1):-
    X = X1, Yn is Y1 - Y, Yn = 1,
    not(member(piece(_, _, X1, Y1), Board)).

canPieceMoveTo(piece(white, pawn, X, Y),Board, X1, Y1):-
    Xn is abs(X - X1),Xn = 1, Yn is Y1 - Y, Yn = 1,
    member(piece(black, _, X1, Y1), Board).

canPieceMoveTo(piece(white, pawn, X, 5),Board, X1, Y1):-
    member(last_move(piece(black,pawn, X_P, 7),X_P, 5),Board),
    Xcheck is abs(X_P- X),
    Xcheck = 1,
    X1 = X_P, Y1 = 6.

canPieceMoveTo(piece(black, pawn, X, Y),Board, X1, Y1):-
    X = X1, Yn is Y - Y1, Yn = 1,
    not(member(piece(_, _, X1, Y1), Board)).

canPieceMoveTo(piece(black, pawn, X, Y),Board, X1, Y1):-
    Xn is abs(X - X1), Xn = 1, Yn is Y - Y1, Yn = 1,
    member(piece(white, _, X1, Y1), Board).

canPieceMoveTo(piece(black, pawn, X, 7),Board, X1, Y1):-
    not(member(piece(_, _, X1, 6), Board)),
    not(member(piece(_, _, X1, Y1), Board)),
    X = X1, Y1 = 5.

canPieceMoveTo(piece(black, pawn, X, 4),Board, X1, Y1):-
    member(last_move(piece(white,pawn, X_P, 2),X_P, 4),Board),
    Xcheck is abs(X_P- X),
    Xcheck = 1,
    X1 = X_P, Y1 = 3.
%rules for king
canPieceMoveTo(piece(Color,king,X,Y),Board,X1,Y1):-
    opponent(Color,OppColor),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,X1,Y1)),
    Ax is abs(X-X1),
    Ax=<1,
    Ay is abs(Y-Y1),
    Ay=<1.

canPieceMoveTo(piece(white,king,4,1), Board, 2, 1):-
    member(piece(white, rook, 1,1),Board),
    not(member(already_moved(piece(white,king,4,1)),Board)),
    not(member(already_moved(piece(white,rook,1,1)),Board)),
    check_l(4,1,2,1,Board),
    opponent(white,OppColor),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,2,1)),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,3,1)),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,4,1)).

canPieceMoveTo(piece(white,king,4,1), Board, 6, 1):-
    member(piece(white, rook, 8,1),Board),
    not(member(already_moved(piece(white,king,4,1)),Board)),
    not(member(already_moved(piece(white,rook,8,1)),Board)),
    check_l(4,1,7,1,Board),
    opponent(white,OppColor),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,4,1)),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,5,1)),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,6,1)).
    

canPieceMoveTo(piece(black,king,4,8), Board, 2, 8):-
    member(piece(black, rook, 1,8),Board),
    not(member(already_moved(piece(black,king,4,8)),Board)),
    not(member(already_moved(piece(black,rook,1,8)),Board)),
    check_l(4,8,2,8,Board),
    opponent(black,OppColor),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,2,8)),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,3,8)),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,4,8)).
    

canPieceMoveTo(piece(black,king,4,8), Board, 6, 8):-
    member(piece(black, rook, 8,8),Board),
    not(member(already_moved(piece(black,king,4,8)),Board)),
    not(member(already_moved(piece(black,rook,8,8)),Board)),
    check_l(4,8,7,8,Board),
    opponent(black,OppColor),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,4,8)),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,5,8)),
    not(piece_can_beat(piece(OppColor,_,_,_),Board,6,8)).
    

%\/Блок для правил описывающих куда фигура бьет.

piece_can_beat(piece(Color,Name,X,Y),Board,X1,Y1):-
    member(piece(Color,Name,X,Y),Board),
    piece_beats(piece(Color,Name,X,Y),Board,X1,Y1).

%Для пешек
piece_beats(piece(white,pawn,X,Y), _, X1,Y1):-
    Xn is abs(X - X1),Xn = 1, Yn is Y1 - Y, Yn = 1.

piece_beats(piece(black,pawn,X,Y), _, X1,Y1):-
    Xn is abs(X - X1), Xn = 1, Yn is Y - Y1, Yn = 1.

%Для короля
piece_beats(piece(_,king,X,Y),_,X1,Y1):-
    Ax is abs(X-X1),
    Ax=<1,
    Ay is abs(Y-Y1),
    Ay=<1.

%Для ферзя
piece_beats(piece(_, queen, X, Y),Board, X1, Y1):-
    canPieceMoveTo(piece(_, queen, X, Y),Board, X1, Y1).

%Для слона.
piece_beats(piece(_, bishop, X, Y),Board, X1, Y1):-
    canPieceMoveTo(piece(_, bishop, X, Y),Board, X1, Y1).

%Для коня.
piece_beats(piece(_, knight, X, Y),Board, X1, Y1):-
    canPieceMoveTo(piece(_, knight, X, Y),Board, X1, Y1).

%Для ладьи
piece_beats(piece(_,rook,X,Y), Board, X1,Y1):-
    check_l(X,Y,X1,Y1,Board).

%Предикаты для возврата возможных ходов для фигуры

%Возможные ходы для короля
possible_moves(piece(Color,king,X,Y),Board, N_X,N_Y):-
    (
        N_X is X + 1, N_Y is Y + 1;
        N_X is X + 1, N_Y is Y;
        N_X is X + 1, N_Y is Y - 1;
        N_X is X - 1, N_Y is Y + 1;
        N_X is X - 1, N_Y is Y;
        N_X is X - 1, N_Y is Y - 1;
        N_X is X, N_Y is Y + 1;
        N_X is X, N_Y is Y - 1
    ),
    can_move(Color,piece(Color,king, X,Y),Board, N_X,N_Y).

%Возможные ходы ферзя
possible_moves(piece(Color,queen,X,Y),Board, N_X,N_Y):-
    between(1,7, Shift),
    (
        N_X is X+Shift, N_Y is Y+Shift;
        N_X is X+Shift, N_Y is Y-Shift;
        N_X is X-Shift, N_Y is Y+Shift;
        N_X is X-Shift, N_Y is Y-Shift;
        N_X is X, N_Y is Y-Shift;
        N_X is X, N_Y is Y+Shift;
        N_X is X-Shift, N_Y is Y;
        N_X is X+Shift, N_Y is Y
    ),
    can_move(Color,piece(Color,queen, X,Y),Board, N_X,N_Y).

%Возможные ходы ладьи
possible_moves(piece(Color,rook,X,Y),Board, N_X,N_Y):-
    between(1,7, Shift),
    (
        N_X is X, N_Y is Y-Shift;
        N_X is X, N_Y is Y+Shift;
        N_X is X-Shift, N_Y is Y;
        N_X is X+Shift, N_Y is Y
    ),
    can_move(Color,piece(Color,rook, X,Y),Board, N_X,N_Y).

%Возможные ходы коня
possible_moves(piece(Color,knight,X,Y),Board, N_X,N_Y):-
    (
        N_X is X + 1, N_Y is Y + 2;
        N_X is X - 1, N_Y is Y + 2;
        N_X is X + 1, N_Y is Y - 2;
        N_X is X - 1, N_Y is Y - 2;
        N_X is X + 2, N_Y is Y + 1;
        N_X is X - 2, N_Y is Y + 1;
        N_X is X + 2, N_Y is Y - 1;
        N_X is X - 2, N_Y is Y - 1
    ),
    can_move(Color,piece(Color,knight, X,Y),Board, N_X,N_Y).

%Возможные ходы пешки
possible_moves(piece(Color,pawn,X,Y),Board, N_X,N_Y):-
    (
        N_X is X + 1, N_Y is Y + 1;
        N_X is X - 1, N_Y is Y + 1;
        N_X is X, N_Y is Y + 2;
        N_X is X, N_Y is Y + 1;
        N_X is X + 1, N_Y is Y - 1;
        N_X is X - 1, N_Y is Y - 1;
        N_X is X, N_Y is Y - 2;
        N_X is X, N_Y is Y - 1
    ),
    can_move(Color,piece(Color,pawn, X,Y),Board, N_X,N_Y).

%Возможные ходы слона
possible_moves(piece(Color,bishop,X,Y),Board, N_X,N_Y):-
    between(1,7, Shift),
    (
        N_X is X+Shift, N_Y is Y+Shift;
        N_X is X+Shift, N_Y is Y-Shift;
        N_X is X-Shift, N_Y is Y+Shift;
        N_X is X-Shift, N_Y is Y-Shift
    ),
    can_move(Color,piece(Color,bishop, X,Y),Board, N_X,N_Y).