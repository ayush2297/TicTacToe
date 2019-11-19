#! /bin/bash 

echo "tic-tac-toe game*************"
#constants
declare MAX_CELLS_AVAILABLE=9
declare PLAYER_SYMBOL="X"
declare COMPUTER_SYMBOL="O"
declare PLAYER_WINS="XXX"
declare COMPUTER_WINS="OOO"

#arrays and dictionaries
declare -a ticTacToeBoard

#resets the board cells with initial values
function reset_the_board(){
	for (( i=1 ; i<=MAX_CELLS_AVAILABLE ; i++ ))
	do
		ticTacToeBoard[$i]="$i"
	done
}

#flip a coin to decide who plays first
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

#show board in proper format
function display_the_board(){
	echo "-------------"
	for (( row=1 ; $row <= $MAX_CELLS_AVAILABLE ; row=$(($row+3)) ))
	do
		echo "| ${ticTacToeBoard[$row]} | ${ticTacToeBoard[$(($row+1))]} | ${ticTacToeBoard[$row+2]} | "
		echo "-------------"
	done
}

#check if the elements passed give us a winner
function check_for_same_elements(){
	elementsAsString=${ticTacToeBoard[$1]}${ticTacToeBoard[$2]}${ticTacToeBoard[$3]}
	case $elementsAsString in
		$PLAYER_WINS)
			echo 1;;
		$COMPUTER_WINS)
			echo 2;;
		*)
			echo 0;;
	esac
}

#checks diagonals for a winner
function check_for_diagonal_win(){
	local returnCell=0
	local caseVariable=$1
	case $caseVariable in
		1|9)
			returnCell=$(check_for_same_elements 1 5 9);;
		3|7)
			returnCell=$(check_for_same_elements 3 5 7);;
		5)
			returnCell=$(($returnCell+$(check_for_same_elements 1 5 9) ))
			returnCell=$(($returnCell+$(check_for_same_elements 3 5 7) ));;
	esac
	echo $returnCell
}

#checks rows for a winner
function check_for_row_win(){
	local returnCell=0
	local caseVariable=$1
	case $caseVariable in
		1|2|3)
			returnCell=$(check_for_same_elements 1 2 3);;
		4|5|6)
			returnCell=$(check_for_same_elements 4 5 6);;
		7|8|9)
			returnCell=$(check_for_same_elements 7 8 9);;
	esac
	echo $returnCell
}

#checks columns for a winner
function check_for_column_win(){
	local returnCell=0
	local caseVariable=$1
	case $caseVariable in
		1|4|7)
			returnCell=$(check_for_same_elements 1 4 7);;
		2|5|8)
			returnCell=$(check_for_same_elements 2 5 8);;
		3|6|9)
			returnCell=$(check_for_same_elements 3 6 9);;
	esac
	echo $returnCell
}

#perform various checks to see if we have a winner
function check_if_this_player_won(){
	local winCheck=0
	local cell="$1"
	if [ $(($cell%2)) -eq 1  ]
	then
		winCheck=$(($winCheck+$(check_for_diagonal_win $cell) ))
	fi
	winCheck=$(($winCheck+$(check_for_row_win $cell) ))
	winCheck=$(($winCheck+$(check_for_column_win	$cell) ))
	echo $winCheck
}

#finding a cell, which when played will make the computer
#win the game
function check_win_possibility(){
	local tempWinCheck=0
	local tempValue=${ticTacToeBoard[$1]}
	local cellToCheck=$1
	ticTacToeBoard[$cellToCheck]=$2
	tempWinCheck=$(check_if_this_player_won $cellToCheck)
	if [ $tempWinCheck -gt 0 ]
	then
		echo $tempWinCheck
		return
	fi
	ticTacToeBoard[$cellToCheck]=$tempValue
	echo 0
}

function insert_in_the_cell(){
	local cellToInsert=$1
	local symbolToInsert=0
	if [ $2 == "user" ]
	then
		symbolToInsert=$PLAYER_SYMBOL
	else
		symbolToInsert=$COMPUTER_SYMBOL
	fi
	if [[ ${ticTacToeBoard[$cellToInsert]} =~ [0-9] ]]
	then
		ticTacToeBoard[$cellToInsert]=$symbolToInsert
	fi
}

#user selects a cell to play its turn
function user_chance(){
	local chosenCell=0
	while [ true ]
	do
		read -p "enter the position you want to play at: " chosenCell
		if [[ $chosenCell -ge 1 ]] && [[ $chosenCell  -le 9 ]] && [[ ${ticTacToeBoard[$chosenCell]} != $COMPUTER_SYMBOL ]]
		then
			break
		fi
	done
	echo $chosenCell
}

#computer plays at random cell
function computer_chance(){
	local chosenCellComp=1
	local winCell=0
	if [ $1 -gt 4 ]
	then
		while [ $chosenCellComp -le $MAX_CELLS_AVAILABLE ]
		do
			if [[ ${ticTacToeBoard[$chosenCellComp]} =~ [1-9] ]]
			then
				winCell=$(check_win_possibility $chosenCellComp $COMPUTER_SYMBOL)
			fi
			if [ $winCell -gt 0 ]
			then
				echo $chosenCellComp
				return
			fi
			((chosenCellComp++))
		done
	fi
	while [ true ]
	do
		winCell=$(($((RANDOM%9))+1))
		if [[ ${ticTacToeBoard[$winCell]} =~ [0-9] ]]
		then
			echo $winCell
			break
		fi
	done
}

function switch_player(){
	if [ $1 == "user" ]
	then
		echo "computer"
	else
		echo "user"
	fi
}

#game starts here
function the_main_exec_starts_here(){
	local checkVal=0
	local whoseChanceIsIt=0
	reset_the_board
	local whoseChanceIsIt=$( toss_to_decide_who_plays_first )
	chanceNumber=1
	while [ $chanceNumber -le $MAX_CELLS_AVAILABLE ]
	do
		local cell=0
		display_the_board
		if [ $whoseChanceIsIt == "user" ]
		then
			cell=$(user_chance)
			insert_in_the_cell $cell $whoseChanceIsIt
			checkVal=$(check_if_this_player_won $cell)
		else
			cell=$(computer_chance $chanceNumber)
			insert_in_the_cell $cell $whoseChanceIsIt
			checkVal=$(check_if_this_player_won $cell)
		fi
		if [ $checkVal -gt 0 ]
		then
			display_the_board
			local whoWon=$whoseChanceIsIt
			exit
		fi
		whoseChanceIsIt=$(switch_player $whoseChanceIsIt)
		((chanceNumber++))
	done
	echo "Its a tie"
}

the_main_exec_starts_here
