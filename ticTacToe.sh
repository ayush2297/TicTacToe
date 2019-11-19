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
			echo "player wins"
			exit ;;
		$COMPUTER_WINS)
			echo "computer wins"
			exit ;;
		*)
			echo "no winner yet..";;
	esac
}

#checks diagonals for a winner
function check_for_diagonal_win(){
	check_for_same_elements 1 5 9
	check_for_same_elements 3 5 7
}

#checks rows for a winner
function check_for_row_win(){
	check_for_same_elements 1 2 3
	check_for_same_elements 4 5 6
	check_for_same_elements 7 8 9
}

#checks columns for a winner
function check_for_column_win(){
	check_for_same_elements 1 4 7
	check_for_same_elements 2 5 8
	check_for_same_elements 3 6 9
}

#perform various checks to see if we have a winner
function check_if_this_player_won(){
	check_for_diagonal_win
	check_for_row_win
	check_for_column_win
}

#user selects a cell to play its turn
function user_chance(){
	local chosenCell=0
	read -p "enter the position you want to play at: " chosenCell
	if [[ $chosenCell -lt 1 ]] || [[ $chosenCell  -gt 9 ]]
	then
		user_chance
		return
	fi
	if [[ ${ticTacToeBoard[$chosenCell]} =~ [0-9] ]] && [[ ${ticTacToeBoard[$chosenCell]} != $COMPUTER_SYMBOL ]]
	then
		ticTacToeBoard[$chosenCell]=$PLAYER_SYMBOL
	else
		echo "cell already occupied.... try another cell"
		user_chance
	fi
}

#computer plays at random cell
function computer_chance(){
	local chosenCell=$(( $((RANDOM%9))+1 ))
	if [[ ${ticTacToeBoard[$chosenCell]} =~ [0-9] ]] && [[ ${ticTacToeBoard[$chosenCell]} != $PLAYER_SYMBOL ]]
	then
		ticTacToeBoard[$chosenCell]=$COMPUTER_SYMBOL
	else
		echo "cell already occupied.... try another cell"
		computer_chance
	fi
}

#game starts here
function the_main_exec_starts_here(){
	local whoseChanceIsIt=0
	reset_the_board
	local whoseChanceIsIt=$( toss_to_decide_who_plays_first )
	chanceNumber=1
	while [ $chanceNumber -le $MAX_CELLS_AVAILABLE ]
	do
		display_the_board
		if [ $whoseChanceIsIt == "user" ]
		then
			user_chance
			check_if_this_player_won
			whoseChanceIsIt="computer"
		else
			computer_chance
			check_if_this_player_won
			whoseChanceIsIt="user"
		fi
	done
	echo "Its a tie"
}

the_main_exec_starts_here
