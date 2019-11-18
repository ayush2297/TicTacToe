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

function toss_to_decide_who_plays_first(){
	local tossResult
	tossResult=$((RANDOM%2))
	if [ $tossResult -eq 0 ]
	then
		echo "user"
	else
		echo "computer"
	fi
}

function the_main_exec_starts_here(){
	local whoseChanceIsIt=0
	reset_the_board
	whoseChanceIsIt=$( toss_to_decide_who_plays_first )
}

the_main_exec_starts_here
