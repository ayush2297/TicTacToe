#! /bin/bash -x

echo "tic-tac-toe game*************"
#constants
declare MAX_CELLS_AVAILABLE=9
declare PLAYER_SYMBOL="X"
declare COMPUTER_SYMBOL="O"

#arrays and dictionaries
declare -a ticTacToeBoard

#resets the board cells with initial values
function reset_the_board(){
	for (( i=1 ; i<=MAX_CELLS_AVAILABLE ; i++ ))
	do
		ticTacToeBoard[$i]="$i"
	done
}

function the_main_exec_starts_here(){
	reset_the_board
}

the_main_exec_starts_here
