vacant(X,Y, Board):- 
    between(1,8,Y),
    between(1,8,X),
    member(piece(_,_, X,Y),Board).
    