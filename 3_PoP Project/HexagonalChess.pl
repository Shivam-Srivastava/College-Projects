%Assignment by CS10B051 and CS10B036

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%How to play---
%The game is started with the "startGame" command.
%Increase the stack size to a reasonable limit before starting the game.
%The game can be played in two modes - Human/Comp
%In the comp mode the human can choose to be black or white.
%A simple GUI has been incorporated.
%For each move the input pattern is - for example--- [pawn,4,6,5,6]. This moves the pawn from 4,6 to 5,6.
%Similarly for other pieces ... [knight, 6,7,8,5] moves the knoght from 6,7 to 8,5.
%The AI for the computer is a depth 2 search with AlphaBeta pruning.
%Enjoy the game!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pBoard(B):-centralize,pFiveSpaces,pCell(B,11,6),pFiveSpaces,nl,centralize,
pFourSpaces,pCell(B,10,5),pOneLine,pCell(B,10,7),pFourSpaces,nl,centralize,
pThreeSpaces,pCell(B,9,4),pOneLine,pCell(B,10,6),pOneLine,pCell(B,9,8),nl,centralize,
pTwoSpaces,pCell(B,8,3),pOneLine,pCell(B,9,5),pOneLine,pCell(B,9,7),pOneLine,pCell(B,8,9),nl,centralize,
pOneSpace,pCell(B,7,2),pOneLine,pCell(B,8,4),pOneLine,pCell(B,9,6),pOneLine,pCell(B,8,8),pOneLine,pCell(B,7,10),nl,centralize,

pCell(B,6,1),pOneLine,pCell(B,7,3),pOneLine,pCell(B,8,5),pOneLine,pCell(B,8,7),pOneLine,pCell(B,7,9),pOneLine,pCell(B,6,11),nl,centralize,

pOneSpace,pCell(B,6,2),pOneLine,pCell(B,7,4),pOneLine,pCell(B,8,6),pOneLine,pCell(B,7,8),pOneLine,pCell(B,6,10),nl,centralize,
pCell(B,5,1),pOneLine,pCell(B,6,3),pOneLine,pCell(B,7,5),pOneLine,pCell(B,7,7),pOneLine,pCell(B,6,9),pOneLine,pCell(B,5,11),nl,centralize,

pOneSpace,pCell(B,5,2),pOneLine,pCell(B,6,4),pOneLine,pCell(B,7,6),pOneLine,pCell(B,6,8),pOneLine,pCell(B,5,10),nl,centralize,
pCell(B,4,1),pOneLine,pCell(B,5,3),pOneLine,pCell(B,6,5),pOneLine,pCell(B,6,7),pOneLine,pCell(B,5,9),pOneLine,pCell(B,4,11),nl,centralize,

pOneSpace,pCell(B,4,2),pOneLine,pCell(B,5,4),pOneLine,pCell(B,6,6),pOneLine,pCell(B,5,8),pOneLine,pCell(B,4,10),nl,centralize,
pCell(B,3,1),pOneLine,pCell(B,4,3),pOneLine,pCell(B,5,5),pOneLine,pCell(B,5,7),pOneLine,pCell(B,4,9),pOneLine,pCell(B,3,11),nl,centralize,

pOneSpace,pCell(B,3,2),pOneLine,pCell(B,4,4),pOneLine,pCell(B,5,6),pOneLine,pCell(B,4,8),pOneLine,pCell(B,3,10),nl,centralize,
pCell(B,2,1),pOneLine,pCell(B,3,3),pOneLine,pCell(B,4,5),pOneLine,pCell(B,4,7),pOneLine,pCell(B,3,9),pOneLine,pCell(B,2,11),nl,centralize,

pOneSpace,pCell(B,2,2),pOneLine,pCell(B,3,4),pOneLine,pCell(B,4,6),pOneLine,pCell(B,4,8),pOneLine,pCell(B,2,10),nl,centralize,
pCell(B,1,1),pOneLine,pCell(B,2,3),pOneLine,pCell(B,3,5),pOneLine,pCell(B,3,7),pOneLine,pCell(B,2,9),pOneLine,pCell(B,1,11),nl,centralize,

pOneSpace,pCell(B,1,2),pOneLine,pCell(B,2,4),pOneLine,pCell(B,3,6),pOneLine,pCell(B,2,8),pOneLine,pCell(B,1,10),nl,centralize,
pTwoSpaces,pCell(B,1,3),pOneLine,pCell(B,2,5),pOneLine,pCell(B,2,7),pOneLine,pCell(B,1,9),nl,centralize,
pThreeSpaces,pCell(B,1,4),pOneLine,pCell(B,2,6),pOneLine,pCell(B,1,8),nl,centralize,
pFourSpaces,pCell(B,1,5),pOneLine,pCell(B,1,7),pFourSpaces,nl,centralize,
pFiveSpaces,pCell(B,1,6),pFiveSpaces.


centralize:-write('                                                ').

pOneSpace:-write('    ').
pTwoSpaces:-write('        ').
pThreeSpaces:-write('            ').
pFourSpaces:-write('                ').
pFiveSpaces:-write('                    ').


pOneLine:-write('____').
pTwoLines:-write('________').
pThreeLines:-write('____________').
pFourLines:- write('________________').
pFiveLines:-write('____________________').


pCell(Board,X,Y):-member([Piece,X,Y,Color],Board),getNotation(Piece,Color,Notation),write(Notation).
pCell(Board,X,Y):- \+member([Piece,X,Y,Color],Board), pOneLine.

getNotation(king,black,bkng).
getNotation(king,white,wkng).
getNotation(queen,black,bque).
getNotation(queen,white,wque).
getNotation(rook,black,brok).
getNotation(rook,white,wrok).
getNotation(bishop,white,wbsh).
getNotation(bishop,black,bbsh).
getNotation(knight,black,bngt).
getNotation(knight,white,wngt).
getNotation(pawn,black,bpwn).
getNotation(pawn,white,wpwn).
%%%%%%%%%%%%%%Game Logic Begins


isGameOver(Board,Player,Result):- (\+member([king,_,_,black],Board),Result=white;\+member([king,_,_,white],Board),Result=black).

startGame:-write('1Player or 2Player?. Enter 1 or 2.'),read(NoP),decideGamePlay(NoP).
decideGamePlay(1):-write('What should human be? White/Black?. Enter white or black '), read(WB),gamePlayCompHuman(WB).
decideGamePlay(2):-gamePlay(Board).	%gamePlay is only for human v/s human.

selectMove(Board,Move,Color) :- 
	compMove(Board,Board,[],PossibleMoves,Color),!,
	bestMoveAlphaBeta(PossibleMoves,BestMove,Value,-1000,Board,Board,Color),nl,write('Chosen Move: '),write(BestMove),write(' With Value:'),write(Value),nl,
	Move = BestMove,!.

chooseMove(Board,human,Color,Move):-readInput(Move,Color),validateMove(Board,Move).
chooseMove(Board,human,Color,Move):-readInput(Move,Color),\+validateMove(Board,Move),chooseMove(Board,human,Color,Move).
chooseMove(Board,comp,Color,Move) :- !,selectMove(Board,Move,Color).
chooseMove(Board,white,Move):-readInput(Move,white),validateMove(Board,Move).
chooseMove(Board,black,Move):-readInput(Move,black),validateMove(Board,Move).

compMove(Board,[],MovesInitial,MovesFinal,Color):-
	MovesFinal = MovesInitial,!.
compMove(Board,[[Piece,X,Y,Color2]|T],MovesInitial,MovesFinal,Color):-
	\+(Color==Color2),%nl,write('Piece:'),write(Piece),write('Piece Color:'),write(Color2),
	!,compMove(Board,T,MovesInitial,MovesFinal,Color),!.
compMove(Board,[[Piece,X,Y,Color2]|T],MovesInitial,MovesFinal,Color):-
	!,move(Board, Piece, X, Y, Color2, MovesPiece),
	Color==Color2,%nl,write('Piece:'),write(Piece),write('Piece Color:'),write(Color2),
	append(MovesPiece,MovesInitial,S),
	!,compMove(Board,T,S,MovesFinal,Color),!.

readInput([Piece,X1,Y1,X2,Y2,Color],CurrentPlayer):-
	write(CurrentPlayer),
	write(' Move: '),read([Piece,X1,Y1,X2,Y2]),nl,
	Color=CurrentPlayer.
% Move will have [pieceName]
makeMove(Board,Board1,[Piece,X1,Y1,X2,Y2,Color]) :- 
	member([P,X2,Y2,C],Board),
	delete(Board,[P,X2,Y2,C],Board3),
	delete(Board3,[Piece,X1,Y1,Color],Board2),
	append(Board2,[[Piece,X2,Y2,Color]],Board1),!.

makeMove(Board,Board1,[Piece,X1,Y1,X2,Y2,Color]) :- 
\+member([_,X2,Y2,_],Board),delete(Board,[Piece,X1,Y1,Color],Board2),append(Board2,[[Piece,X2,Y2,Color]],Board1),!.
validateMove(Board,[Piece,X1,Y1,X2,Y2,Color]) :- 
	member([Piece,X1,Y1,Color],Board),!,
	move(Board,Piece,X1,Y1,Color,Moves),
	member([Piece,X1,Y1,X2,Y2,Color],Moves).

opponentsPiece(Board,X2,Y2,Color):-member([_,X2,Y2,OpColor],Board),\+(OpColor==Color).
noPiece(Board,X,Y)	:-	\+ member([_,X,Y,Color],Board).
notSamePiece(X1,Y1,Color,Board):- member([_,X1,Y1,C],Board),\+(C==Color).

%%%%%%%%%%%%%%Game Logic ends
gamePlayCompHuman(white):-initBoard(Board),!,gamePlayCompHuman(Board,human,white,Result),!.%Human is white. Passing the color of the human
gamePlayCompHuman(black):-initBoard(Board),!,gamePlayCompHuman(Board,comp,white,Result),!.	%Comp is white	""


gamePlayCompHuman(Board,Player,PlayerColor,Result):-isGameOver(Board,Player,Result),!,announce(Result).

%gamePlayCompHuman(Board,comp,PlayerColor,Result):- chooseMove(Board,PlayerColor,Move),makeMove(Board,Board1,Move),nextPlayer(Player,Player1),write('Move made: '),write(Move),nl,write('Board is: '),write(Board1),nl,gamePlay(Board1,Player1,Result).

gamePlayCompHuman(Board,Player,PlayerColor,Result) :- chooseMove(Board,Player,PlayerColor,Move),makeMove(Board,Board1,Move),nextPlayer(Player,Player1),nextPlayer(PlayerColor,Player1Color),write('Move made: '),write(Move),nl,write('Board is:'),nl,write(Board1),nl,pBoard(Board1),nl,!,gamePlayCompHuman(Board1,Player1,Player1Color,Result),!.

gamePlay(Board,Player,Result) :- isGameOver(Board,Player,Result),!,announce(Result).

gamePlay(Board, Player, Result) :- chooseMove(Board,Player,Move),makeMove(Board,Board1,Move),nextPlayer(Player,Player1),write('Move made: '),write(Move),nl,write('Board is:'),nl,write(Board1),nl,pBoard(Board1),nl,gamePlay(Board1,Player1,Result).


gamePlay(Board):-initBoard(Board),gamePlay(Board,white,Result).
announce(Result):-nl,write('Winner is:'),write(Result),nl.

nextPlayer(human,comp).
nextPlayer(comp,human).
nextPlayer(white,black).
nextPlayer(black,white).


%%%%%%%%%%%%%%%%%Alpha Beta
% In this alpha beta we pass the move and the board and get its value.
% We iterate over all the possible moves available to us and get the value of each.
% Then choose the move with the highest value.
bestMoveAlphaBeta([FirstMove],BestMove,Value,BestValue,Board,TempBoard,MaxColor):-		%Initialize BestValue to -1000
%nextPlayer(MaxColor,MinColor),
	alphaBeta(FirstMove,Board,TempBoard,-1000,1000,beta,1,MaxColor,ReturnedValue),
	%write('Value returne!!!!!!!!!!d: '),write(ReturnedValue),nl,
	%write('Move explored: '),write(FirstMove),nl,
	BestMove = FirstMove,
	Value = ReturnedValue,!.
bestMoveAlphaBeta([FirstMove|OtherMoves],BestMove,Value,BestValue,Board,TempBoard,MaxColor):-		%Initialize BestValue to -1000
%nextPlayer(MaxColor,MinColor),
%	write('Testing move: '),write(FirstMove),write(' Moves left to check:'),write(OtherMoves),nl,
	alphaBeta(FirstMove,Board,TempBoard,-1000,1000,beta,1,MaxColor,ReturnedVal),
	%write('Value returned: '),write(ReturnedVal),nl,
	%write('Move explored: '),write(FirstMove),nl,
	bestMoveAlphaBeta(OtherMoves,MoveGot,ValGot,BestValue,Board,Board,MaxColor),
	update(MoveGot,ValGot,FirstMove,ReturnedVal,BestMove,Value),!.

update(MoveGot,ValGot,FirstMove,ReturnedVal,BestMove,Value) :-
	ReturnedVal>ValGot,
	Value = ReturnedVal,
	BestMove = FirstMove,!.

update(MoveGot,ValGot,FirstMove,ReturnedVal,BestMove,Value) :-
	ReturnedVal=<ValGot,
	Value = ValGot,
	BestMove = MoveGot,!.
pieceValueTable(Table):-Table=[[pawn,1],[king,100],[queen,10],[rook,5],[bishop,3],[knight,3]].

getValueOfPiece(Piece,Color,PieceVal,MyColor):- \+(MyColor==Color),pieceValueTable(Table),member([Piece,X],Table),PieceVal = -X,!.
getValueOfPiece(Piece,Color,PieceVal,MyColor):-(MyColor==Color),pieceValueTable(Table),member([Piece,X],Table),PieceVal = X,!.


valueOfBoard(Board,[],Color,0):-!.
valueOfBoard(Board,[[Piece,X,Y,Color]|OtherPieces],MyColor,Value):-
	valueOfBoard(Board,OtherPieces,MyColor,Value1),!,
	getValueOfPiece(Piece,Color,PieceVal,MyColor),
	Value is Value1+PieceVal,!.
value(Board,alpha,ReturnVal,Color):-
	valueOfBoard(Board,Board,Color,Value),
	ReturnVal is -Value,!.
value(Board,beta,ReturnVal,Color):-
	valueOfBoard(Board,Board,Color,Value),
	ReturnVal is Value,!.

alphaBeta(Move,Board,TempBoard,AlphaVal,BetaVal,PlayerType,0,Color,Value):-
%	write('Leaf'),
%	write('At LeafNode: '),
	makeMove(TempBoard,Board1,Move),
%	write('Made Move: '),write(Move),nl,write('Now board has value:  '),
	value(Board1,PlayerType,ReturnVal,Color),Value is ReturnVal,!.
	%Here we are getting a "Move" that can be made on the Original "Board"
	%So we first need to make that move and pass the resulting Moves
	%As the "child" in the above pseudo code.

alphaBeta(Move,Board,TempBoard,AlphaVal,BetaVal,alpha,D,Color,Value):-
	D>0,%write('Trying our move:'),write(Move),nl,
	makeMove(TempBoard,Board1,Move),
	nextPlayer(Color,OpponentColor),	
	compMove(Board1,Board1,[],PossibleMoves,OpponentColor),
	D1 is D-1,!,%Check the cut here
	loopOverMovesGetValue(PossibleMoves,Board1,AlphaVal,BetaVal,D1,beta,OpponentColor,Value),!.
				
alphaBeta(Move,Board,TempBoard,AlphaVal,BetaVal,beta,D,Color,Value):-
	D>0,
	makeMove(TempBoard,Board1,Move),
	nextPlayer(Color,OpponentColor),
%	write(Board1),	
	compMove(Board1,Board1,[],PossibleMoves,OpponentColor),
	D1 is D-1,!,			%Check the cut here	
	loopOverMovesGetValue(PossibleMoves,Board1,AlphaVal,BetaVal,D1,alpha,OpponentColor,Value),!.%,write('After Loop:'),write(Value).
%getting a stack overflow after makemove, before D1 is D-1 statement.


%Here we need to choose the minimum possible value as beta node invokes this.


loopOverMovesGetValue([],B,Alpha,Beta,D1,alpha,_,Beta).%:-write('Came HERE!').
loopOverMovesGetValue([],B,Alpha,Beta,D1,beta,_,Alpha).%:-write('Came HERE!').

loopOverMovesGetValue([FirstMove|OtherMoves],Board,AlphaVal,BetaVal,D1,alpha,Color,ReturnVal):-
%	write('Before call alpha'),write('Depth: '),write(D1),nl,
	alphaBeta(FirstMove,Board,Board,AlphaVal,BetaVal,alpha,D1,Color,Value),
%	write('After call alpha'),write('Depth: '),write(D1),nl,
	cutoff(OtherMoves,Board,Value,AlphaVal,BetaVal,D1,alpha,Color,ReturnVal),!.	
%if we are passing alpha to cutoff we should select the minimum value.
%if we are passing beta to cutoff we should select the maximum value.
%Here we need to choose the maximum possible value as alpha node invokes this.
loopOverMovesGetValue([FirstMove|OtherMoves],Board,AlphaVal,BetaVal,D1,beta,Color,ReturnVal):-
%	write('ReturnVal'),write(ReturnVal),write('Before call beta'),write('Depth: '),write(D1),nl,
	alphaBeta(FirstMove,Board,Board,AlphaVal,BetaVal,beta,D1,Color,Value),
%	write('ReturnVal'),write(ReturnVal),write('After call beta'),write('Depth: '),write(D1),nl,
	cutoff(OtherMoves,Board,Value,AlphaVal,BetaVal,D1,beta,Color,ReturnVal),!.
	
	%cutoff also decides whether it has to choose the minimum value or the maximum value.
	%cutoff decides if the next iteration of loopOverMovesGetValue should be done or not based on the Alpha,Beta values.

	%In "loopOverMovesGetValue" we are passing the Possible Moves it has to iterate over. For these moves it has to compute the best 		value and return it as "ReturnVal".
%cutoff([],_,_,AlphaVal,BetaVal,_,beta,_,AlphaVal):-write('At cutOffbeta!'),!.
%cutoff([],_,_,AlphaVal,BetaVal,_,alpha,_,BetaVal):-write('At cutOffalpha!'),!,write(BetaVal),nl.
%cutoff(_,_,_,_,_,0,_,_).
cutoff(OtherMoves,_,ReturnVal,AlphaVal,BetaVal,D1,_,Color,_):-		%CutOff region
	AlphaVal>=BetaVal,!.

cutoff(OtherMoves,Board,ReturnedVal,AlphaVal,BetaVal,D1,beta,Color,X):-
	ReturnedVal>AlphaVal,AlphaVal=<BetaVal,!,
	loopOverMovesGetValue(OtherMoves,Board,ReturnedVal,BetaVal,D1,beta,Color,X),!.

cutoff(OtherMoves,Board,ReturnedVal,AlphaVal,BetaVal,D1,beta,Color,X):-
	ReturnedVal=<AlphaVal,AlphaVal=<BetaVal,!,
	loopOverMovesGetValue(OtherMoves,Board,AlphaVal,BetaVal,D1,beta,Color,X),!.

cutoff(OtherMoves,Board,ReturnedVal,AlphaVal,BetaVal,D1,alpha,Color,X):-
	ReturnedVal=<BetaVal,AlphaVal=<BetaVal,!,
	loopOverMovesGetValue(OtherMoves,Board,AlphaVal,ReturnedVal,D1,alpha,Color,X),!.

cutoff(OtherMoves,Board,ReturnedVal,AlphaVal,BetaVal,D1,alpha,Color,X):-
	ReturnedVal>BetaVal,AlphaVal=<BetaVal,!,
	loopOverMovesGetValue(OtherMoves,Board,AlphaVal,BetaVal,D1,alpha,Color,X),!.





/*
function alphabeta(node, depth, α, β, Player)         
    if  depth = 0 or node is a terminal node
        return the heuristic value of node
    if  Player = MaxPlayer
        for each child of node
            α := max(α, alphabeta(child, depth-1, α, β, not(Player) ))     
            if β ≤ α
                break                             (* Beta cut-off *)
        return α
    else
        for each child of node
            β := min(β, alphabeta(child, depth-1, α, β, not(Player) ))     
            if β ≤ α
                break                             (* Alpha cut-off *)
        return β
(* Initial call *)
alphabeta(origin, depth, -infinity, +infinity, MaxPlayer)
*/







%%%%%%%%%%%%%%%%%Alpha Beta


initBoard1(Board) :- Board = [[king,11,6,white],
				[king,3,9,black]
				].


initBoard(Board)	:-	Board = [
				[bishop,1,6,white],
				[bishop,2,6,white],
				[bishop,3,6,white],
				[rook,1,4,white],
				[rook,1,8,white],
				[king,1,7,white],
				[queen,1,5,white],
				[pawn,1,3,white],
				[pawn,2,4,white],
				[pawn,3,5,white],
				[pawn,4,6,white],
				[pawn,3,7,white],
				[pawn,2,8,white],
				[pawn,1,9,white],
				[bishop,11,6,black],
				[bishop,10,6,black],
				[bishop,9,6,black],
				[rook,9,4,black],
				[rook,9,8,black],
				[king,10,7,black],
				[queen,10,5,black],
				[pawn,8,3,black],
				[pawn,8,4,black],
				[pawn,8,5,black],
				[pawn,8,6,black],
				[pawn,8,7,black],
				[pawn,8,8,black],
				[pawn,8,9,black],
				[knight,9,5,black],
				[knight,9,7,black],
				[knight,2,5,white],
				[knight,2,7,white]
				].%,write('type your move'),nl,read(Move).			
validCoord(X,Y)	:- 
				Coords = [[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[1,8],[1,9],[1,10],[1,11],
				[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7],[2,8],[2,9],[2,10],[2,11],
				[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[3,7],[3,8],[3,9],[3,10],[3,11],
				[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7],[4,8],[4,9],[4,10],[4,11],
				[5,1],[5,2],[5,3],[5,4],[5,5],[5,6],[5,7],[5,8],[5,9],[5,10],[5,11],
				[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7],[6,8],[6,9],[6,10],[6,11],
				[7,2],[7,3],[7,4],[7,5],[7,6],[7,7],[7,8],[7,9],[7,10],
				[8,3],[8,4],[8,5],[8,6],[8,7],[8,8],[8,9],
				[9,4],[9,5],[9,6],[9,7],[9,8],
				[10,5],[10,6],[10,7],
				[11,6]
				],
				member([X,Y], Coords).
				

move(Board,pawn,X,Y,Color,Moves) :- 				move2step(Board,pawn,X,Y,Color,[],A),
									move1step(Board,pawn,X,Y,Color,A,S),
									killRight(Board,pawn,X,Y,Color,S,D),
									killLeft(Board,pawn,X,Y,Color,D,Moves),!.

move(Board,king,X,Y,Color,MovesList):-	move1_0(Board,king,X,Y,Color,[],Q),
									move1_60(Board,king,X,Y,Color,Q,W),
									move1_120(Board,king,X,Y,Color,W,E),
									move1_180(Board,king,X,Y,Color,E,R),
									move1_240(Board,king,X,Y,Color,R,T),
									move1_300(Board,king,X,Y,Color,T,G),
									move1_30(Board,king,X,Y,Color,G,H),
									move1_90(Board,king,X,Y,Color,H,J),
									move1_150(Board,king,X,Y,Color,J,K),
									move1_210(Board,king,X,Y,Color,K,L),
									move1_270(Board,king,X,Y,Color,L,P),
									move1_330(Board,king,X,Y,Color,P,MovesList),!.

move(Board,rook,X,Y,Color,MovesList):-	move0(Board,rook,X,Y,X,Y,Color,[],W),
									move60(Board,rook,X,Y,X,Y,Color,W,A),
									move120(Board,rook,X,Y,X,Y,Color,A,S),
									move180(Board,rook,X,Y,X,Y,Color,S,T),
									move240(Board,rook,X,Y,X,Y,Color,T,F),
									move300(Board,rook,X,Y,X,Y,Color,F,MovesList),!.
									
move(Board,queen,X,Y,Color,MovesList):-				move0(Board,queen,X,Y,X,Y,Color,[],W),
									move60(Board,queen,X,Y,X,Y,Color,W,A),
									move120(Board,queen,X,Y,X,Y,Color,A,S),
									move180(Board,queen,X,Y,X,Y,Color,S,T),
									move240(Board,queen,X,Y,X,Y,Color,T,F),
									move300(Board,queen,X,Y,X,Y,Color,F,G),
									move30(Board,queen,X,Y,X,Y,Color,G,H),
									move90(Board,queen,X,Y,X,Y,Color,H,J),
									move150(Board,queen,X,Y,X,Y,Color,J,K),
									move210(Board,queen,X,Y,X,Y,Color,K,L),
									move270(Board,queen,X,Y,X,Y,Color,L,P),
									move330(Board,queen,X,Y,X,Y,Color,P,MovesList),!.
									
move(Board,bishop,X,Y,Color,MovesList):-move30(Board,bishop,X,Y,X,Y,Color,[],W),
									move90(Board,bishop,X,Y,X,Y,Color,W,A),
									move150(Board,bishop,X,Y,X,Y,Color,A,S),
									move210(Board,bishop,X,Y,X,Y,Color,S,T),
									move270(Board,bishop,X,Y,X,Y,Color,T,F),
									move330(Board,bishop,X,Y,X,Y,Color,F,MovesList),!.

move(Board,knight,X,Y,Color,MovesList):-
	moveK1(Board,knight,X,Y,Color,[],W),
	moveK2(Board,knight,X,Y,Color,W,A),
	moveK3(Board,knight,X,Y,Color,A,S),
	moveK4(Board,knight,X,Y,Color,S,T),
	moveK5(Board,knight,X,Y,Color,T,F),
	moveK6(Board,knight,X,Y,Color,F,G),
	moveK7(Board,knight,X,Y,Color,G,H),
	moveK8(Board,knight,X,Y,Color,J,K),
	moveK9(Board,knight,X,Y,Color,K,L),
	moveK10(Board,knight,X,Y,Color,L,P),
	moveK11(Board,knight,X,Y,Color,H,J),
	moveK12(Board,knight,X,Y,Color,P,MovesList),!.
	

moveK1(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=6,
	X2 is X+2,
	Y2 is Y+1,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.

moveK1(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y<6,
	X2 is X+3,
	Y2 is Y+1,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.	

moveK1(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.

moveK6(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=6,
	X2 is X-3,
	Y2 is Y+1,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.

moveK6(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y<6,
	X2 is X-2,
	Y2 is Y+1,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.	

moveK6(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

moveK7(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>6,
	X2 is X-2,
	Y2 is Y-1,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.

moveK7(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<6,
	X2 is X-3,
	Y2 is Y-1,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.	

moveK7(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

moveK12(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>6,
	X2 is X+3,
	Y2 is Y-1,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.

moveK12(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<6,
	X2 is X+2,
	Y2 is Y-1,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.	

moveK12(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.

moveK2(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<4,
	X2 is X+3,
	Y2 is Y+2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK2(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=5,
	X2 is X+2,
	Y2 is Y+2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK2(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=6,
	X2 is X+1,
	Y2 is Y+2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK2(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.

moveK5(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<4,
	X2 is X-1,
	Y2 is Y+2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK5(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=5,
	X2 is X-2,
	Y2 is Y+2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK5(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=6,
	X2 is X-3,
	Y2 is Y+2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK5(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

moveK8(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<6,
	X2 is X-3,
	Y2 is Y-2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK8(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=7,
	X2 is X-2,
	Y2 is Y-2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK8(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=8,
	X2 is X-1,
	Y2 is Y-2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK8(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.

moveK11(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<6,
	X2 is X+1,
	Y2 is Y-2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK11(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=7,
	X2 is X+2,
	Y2 is Y-2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK11(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=8,
	X2 is X+3,
	Y2 is Y-2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK11(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

moveK7(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<6,
	X2 is X+1,
	Y2 is Y-2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK7(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=7,
	X2 is X+2,
	Y2 is Y-2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK7(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=8,
	X2 is X+3,
	Y2 is Y-2,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK7(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.

moveK3(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=6,
	X2 is X-1,
	Y2 is Y+3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK3(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=5,
	X2 is X,
	Y2 is Y+3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK3(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=4,
	X2 is X+1,
	Y2 is Y+3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK3(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=3,
	X2 is X+2,
	Y2 is Y+3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK3(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.

moveK4(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=6,
	X2 is X-2,
	Y2 is Y+3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK4(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=5,
	X2 is X-1,
	Y2 is Y+3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK4(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=4,
	X2 is X,
	Y2 is Y+3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK4(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<3,
	X2 is X+1,
	Y2 is Y+3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK4(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.

moveK9(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=9,
	X2 is X+1,
	Y2 is Y-3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK9(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=8,
	X2 is X,
	Y2 is Y-3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK9(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=7,
	X2 is X-1,
	Y2 is Y-3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK9(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<6,
	X2 is X-2,
	Y2 is Y-3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK9(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.

moveK10(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y>=9,
	X2 is X+2,
	Y2 is Y-3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK10(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=8,
	X2 is X+1,
	Y2 is Y-3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
	%MovesListI=MovesListF.
moveK10(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=7,
	X2 is X,
	Y2 is Y-3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK10(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	
	Y=<6,
	X2 is X-1,
	Y2 is Y-3,
	validCoord(X2,Y2),
	(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),
	opponentsPiece(Board,X2,Y2,Color) ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
	MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
moveK10(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.

/*
move(Board,pawn,X,Y,white,Moves) :- move2step(Board,pawn,X,Y,white,[],A),
									move1step(Board,pawn,X,Y,white,A,S),
									killRight(Board,pawn,X,Y,white,S,D),
									killLeft(Board,pawn,X,Y,white,D,Moves).
*/
/*TODO:::enPassant capture of pawns*/
/*DONE*/
/*
TODO: 

-Check things working.
-Make AI.
*/
isInitialRow(X,Y) :- (X is 1,Y is 3);(X is 2,Y is 4);(X is 3, Y is 5);(X is 3,Y is 7);(X is 2,Y is 8);(X is 1,Y is 9).
move2step(Board,pawn,X,Y,white,I,F)	:-				X1 is X+2,
										Y1 is Y,
										isInitialRow(X,Y),
										validCoord(X1,Y1),
										noPiece(Board,X1-1,Y1),
										noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,white]|I],!.


/*DONE*/
move2step(Board,pawn,X,Y,black,I,F)	:-				X1 is X-2,
										Y1 is Y,
										X is 8,
										\+(Y==6),
										validCoord(X1,Y1),
										noPiece(Board,X1+1,Y1),		
										noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,black]|I],!.
/*DONE*/
move2step(Board,pawn,_,_,_,I,F)	:- F=I.

/*DONE*/
move1step(Board,pawn,X,Y,white,I,F)	:-				X1 is X+1,
										Y1 is Y,
										validCoord(X1,Y1),
										noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,white]|I],!.

/*DONE*/
move1step(Board,pawn,X,Y,black,I,F)	:-				X1 is X-1,
										Y1 is Y,
										validCoord(X1,Y1),
										noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,black]|I],!.
/*DONE*/
move1step(Board,pawn,_,_,_,I,F)	:- F=I.

killRight(Board,pawn,X,Y,white,I,F)	:-	Y > 5,
										X1 is X+1,
										Y1 is Y+1,
										notSamePiece(X1,Y1,white,Board),
										validCoord(X1,Y1),
										\+ noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,white]|I],!.

killRight(Board,pawn,X,Y,white,I,F)	:-	Y < 6,
										X1 is X+2,
										Y1 is Y+1,
										notSamePiece(X1,Y1,white,Board),
										validCoord(X1,Y1),
										\+ noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,white]|I],!.

killRight(Board,pawn,X,Y,black,I,F)	:-	Y > 5,
										X1 is X-2,
										Y1 is Y+1,
										notSamePiece(X1,Y1,black,Board),
										validCoord(X1,Y1),
										\+ noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,white]|I],!.

killRight(Board,pawn,X,Y,black,I,F)	:-	Y < 6,
										X1 is X-1,
										Y1 is Y+1,
										notSamePiece(X1,Y1,black,Board),
										validCoord(X1,Y1),
										\+ noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,black]|I],!.
killRight(Board,pawn,_,_,_,I,F)	:- F=I.

killLeft(Board,pawn,X,Y,white,I,F)	:-	Y > 6,
										X1 is X+2,
										Y1 is Y-1,
										notSamePiece(X1,Y1,white,Board),
										validCoord(X1,Y1),
										\+ noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,white]|I],!.

killLeft(Board,pawn,X,Y,white,I,F)	:-	Y < 7,
										X1 is X+1,
										Y1 is Y-1,
										notSamePiece(X1,Y1,white,Board),
										validCoord(X1,Y1),
										\+ noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,white]|I],!.

killLeft(Board,pawn,X,Y,black,I,F)	:-	Y > 6,
										X1 is X-1,
										Y1 is Y-1,
										notSamePiece(X1,Y1,black,Board),
										validCoord(X1,Y1),
										\+ noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,black]|I],!.

killLeft(Board,pawn,X,Y,black,I,F)	:-	Y < 7,
										X1 is X-2,
										Y1 is Y-1,
										notSamePiece(X1,Y1,black,Board),
										validCoord(X1,Y1),
										\+ noPiece(Board,X1,Y1),
										F = [[pawn,X,Y,X1,Y1,black]|I],!.
killLeft(Board,pawn,_,_,_,I,F)	:- F=I.



move1_0(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	X2 is X+1,
										Y2 is Y,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
				

move1_0(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_60(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y>5,
										X2 is X,
										Y2 is Y+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_60(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y<6,
										X2 is X+1,
										Y2 is Y+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_60(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_120(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y>5,
										X2 is X-1,
										Y2 is Y+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_120(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y<6,
										X2 is X,
										Y2 is Y+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_120(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_180(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	X2 is X-1,
										Y2 is Y,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_180(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_240(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y>6,
										X2 is X,
										Y2 is Y-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_240(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y<7,
										X2 is X-1,
										Y2 is Y-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_240(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_300(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y>6,
										X2 is X+1,
										Y2 is Y-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_300(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y<7,
										X2 is X,
										Y2 is Y-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_300(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_30(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	X2 is X+2,
										Y<6,
										Y2 is Y+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.

move1_30(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	X2 is X+1,
										Y>5,
										Y2 is Y+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_30(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_90(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y<5,
										X2 is X+1,
										Y2 is Y+2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_90(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y>5,
										X2 is X-1,
										Y2 is Y+2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.

move1_90(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y=5,
										X2 is X,
										Y2 is Y+2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_90(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_150(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y<6,
										X2 is X-1,
										Y2 is Y+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.

move1_150(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y>5,
										X2 is X-2,
										Y2 is Y+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_150(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_210(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y>6,
										X2 is X-1,
										Y2 is Y-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.

move1_210(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y<7,
										X2 is X-2,
										Y2 is Y-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_210(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_270(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y>7,
										X2 is X+1,
										Y2 is Y-2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_270(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y is 7,
										X2 is X,
										Y2 is Y-2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_270(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y<7,
										X2 is X-1,
										Y2 is Y-2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
move1_270(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.

move1_330(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y>6,
										X2 is X+2,
										Y2 is Y-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.

move1_330(Board,Piece,X,Y,Color,MovesListI,MovesListF)	:-	Y<7,
										X2 is X+1,
										Y2 is Y-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI],!.
										%MovesListI=MovesListF.
move1_330(_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move0(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	X2 is X1+1,
										Y2 is Y1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move0(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move0(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move30(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	X2 is X1+2,
										Y1<6,
										Y2 is Y1+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move30(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move30(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	X2 is X1+1,
										Y1>5,
										Y2 is Y1+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move30(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move30(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move60(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	X2 is X1+1,
										Y1<6,
										Y2 is Y1+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]) ),
										move60(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move60(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	X2 is X1,
										Y1>5,
										Y2 is Y1+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move60(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move60(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI,!.
									
move90(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1<5,
										X2 is X1+1,
										Y2 is Y1+2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move90(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move90(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1==5,
										X2 is X1,
										Y2 is Y1+2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move90(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move90(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1>5,
										X2 is X1-1,
										Y2 is Y1+2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move90(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move90(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move120(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1<6,
										X2 is X1,
										Y2 is Y1+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move120(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move120(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1>5,
										X2 is X1-1,
										Y2 is Y1+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move120(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move120(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move150(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1<6,
										X2 is X1-1,
										Y2 is Y1+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move150(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move150(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1>5,
										X2 is X1-2,
										Y2 is Y1+1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move150(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move150(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									

move180(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	X2 is X1-1,
										Y2 is Y1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move180(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move180(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move210(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1>6,
										X2 is X1-1,
										Y2 is Y1-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move210(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move210(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1<7,
										X2 is X1-2,
										Y2 is Y1-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move210(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move210(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move240(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1>6,
										X2 is X1,
										Y2 is Y1-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move240(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move240(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1<7,
										X2 is X1-1,
										Y2 is Y1-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move240(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move240(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move270(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1>7,
										X2 is X1+1,
										Y2 is Y1-2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move270(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move270(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1==7,
										X2 is X1,
										Y2 is Y1-2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move270(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move270(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1<7,
										X2 is X1-1,
										Y2 is Y1-2,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move270(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move270(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move300(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1>6,
										X2 is X1,
										Y2 is Y1-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move300(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move300(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1<7,
										X2 is X1,
										Y2 is Y1-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move300(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move300(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									
move330(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1>6,
										X2 is X1+2,
										Y2 is Y1-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move330(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move330(Board,Piece,X,Y,X1,Y1,Color,MovesListI,MovesListF)	:-	Y1<7,
										X2 is X1+1,
										Y2 is Y1-1,
										validCoord(X2,Y2),
										(noPiece(Board,X2,Y2);((\+noPiece(Board,X2,Y2),opponentsPiece(Board,X2,Y2,Color) ),MovesListF = [[Piece,X,Y,X2,Y2,Color]|MovesListI]),! ),
										move330(Board,Piece,X,Y,X2,Y2,Color,[[Piece,X,Y,X2,Y2,Color]|MovesListI],MovesListF),!.
move330(_,_,_,_,_,_,_,MovesListI,MovesListF):-MovesListF = MovesListI.
									

