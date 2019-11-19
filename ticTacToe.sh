#! /bin/bash 

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

function display_the_board(){
	echo "-------------"
	for (( row=1 ; $row <= $MAX_CELLS_AVAILABLE ; row=$(($row+3)) ))
	do
		echo "| ${ticTacToeBoard[$row]} | ${ticTacToeBoard[$(($row+1))]} | ${ticTacToeBoard[$row+2]} | "
		echo "-------------"
	done
}

function user_chance(){
	read -p "enter the position you want to play at: " chosenCell
	if [[ $chosenCell -lt 1 ]] || [[ $chosenCell  -gt 9 ]]
	then
		user_chance
		return
	fi
	if [[ ${ticTacToeBoard[$chosenCell]} =~ [0-9] ]]
	then
		ticTacToeBoard[$row]=$PLAYER_SYMBOL
	else
		echo "cell already occupied.... try another cell"
		user_chance
	fi
}

function the_main_exec_starts_here(){
	local whoseChanceIsIt=0
	local switchCounter=0
	reset_the_board
	whoseChanceIsIt=$( toss_to_decide_who_plays_first )
	if [ $whoseChanceIsIt == "user" ]
	then
		display_the_board
		user_chance
	else
		echo "comp plays"
	fi
}

the_main_exec_starts_here
