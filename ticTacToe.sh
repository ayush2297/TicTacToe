#! /bin/bash 

echo "tic-tac-toe game*************"
#constants
declare MAX_CELLS_AVAILABLE=9
declare PLAYER_SYMBOL="X"
declare COMPUTER_SYMBOL="O"

#arrays and dictionaries
declare -a ticTacToeBoard

#variables
declare rowColCount=$(echo "sqrt($MAX_CELLS_AVAILABLE)" | bc)

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
		ticTacToeBoard[$chosenCell]=$PLAYER_SYMBOL
	else
		echo "cell already occupied.... try another cell"
		user_chance
	fi
}

function check_diagonals_for_win(){
	local mainDiagWinning=1
	#checking main diagonal
	for (( i=1 ; $i<$MAX_CELLS_AVAILABLE ; i=$(($i+$rowColCount+1)) ))
	do
		if [ ${ticTacToeBoard[$i]} == ${ticTacToeBoard[$(($i+$rowColCount+1))]} ]
		then
			mainDiagWinning=$(($mainDiagWinning+1))
		else
			break
		fi
	done
	if [[ $mainDiagWinning -eq $rowColCount ]] && [[ ${ticTacToeBoard[1]} == $1 ]]
	then
		echo 1
		return
	fi

	#checking for reverse diagonal
	local revDiagWinning=1
	for (( i=$rowColCount ; $i<$MAX_CELLS_AVAILABLE ; i=$(($i+$rowColCount-1)) ))
	do
		if [ ${ticTacToeBoard[$i]} == ${ticTacToeBoard[$(($i+$rowColCount-1))]} ]
		then
			revDiagWinning=$(($revDiagWinning+1))
		else
			break
		fi
	done
	if [[ $revDiagWinning -eq $rowColCount ]] && [[ ${ticTacToeBoard[$rowColCount]} == $1 ]]
	then
		echo 1
		return
	fi
	#if no winning condition then ....
	echo 0
}

function check_rows_for_win(){
	for (( row=0 ; $row< $rowColCount ; row++ ))
	do
		local win=0
		for (( i=$((1+$row*3)) ; $i<$(($rowColCount*$(($row+1)))) ; i++ ))
		do
			if [ ${ticTacToeBoard[$i]} == ${ticTacToeBoard[$i+1]} ]
			then
				win=$(($win+1))
			else
				break
			fi
		done
		if [[ $win -eq $(($rowColCount-1)) ]] && [[ ${ticTacToeBoard[$((1+$row*3))]} == $1 ]]
		then
			echo 1
			return
		fi
	done
	echo 0
}

function check_if_this_player_won(){
	local thisPlayer=$1
	local winCounter=0
	local thisPlayerSymbol=0
	if [ $thisPlayer == "user" ]
	then
		thisPlayerSymbol=$PLAYER_SYMBOL
	else
		thisPlayerSymbol=$COMPUTER_SYMBOL
	fi
	winCounter=$(($winCounter+ $( check_diagonals_for_win $thisPlayerSymbol ) ))
	winCounter=$(($winCounter+ $( check_rows_for_win $thisPlayerSymbol ) ))
	#winCounter=$(($winCounter+ $( check_cols_for_win $thisPlayerSymbol ) ))
	echo $winCounter
}

function the_main_exec_starts_here(){
	local whoseChanceIsIt=0
	local weHaveAWinner=0
	reset_the_board
	local whoseChanceIsIt=$( toss_to_decide_who_plays_first )
	chanceNumber=1
	while [ $chanceNumber -le $MAX_CELLS_AVAILABLE ]
	do
		if [ $whoseChanceIsIt == "user" ]
		then
			display_the_board
			user_chance
			weHaveAWinner=$( check_if_this_player_won $whoseChanceIsIt )
		else
			echo "comp plays"
		fi
		if [ $weHaveAWinner -gt 0 ]
		then
			break
		fi
	done
}

the_main_exec_starts_here
