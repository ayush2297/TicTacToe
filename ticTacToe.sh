#! /bin/bash -x

echo "tic-tac-toe game*************"

#constants
declare MAX_CELLS_AVAILABLE=9
declare PLAYER_SYMBOL="X"
declare COMPUTER_SYMBOL="O"
declare PLAYER_WINS="XXX"
declare COMPUTER_WINS="OOO"
declare CENTER_CELL=5

#arrays and dictionaries
declare -a ticTacToeBoard
declare -a cornerCells=([1]=1 [2]=3 [3]=7 [4]=9)
declare -a sideCells=([1]=2 [2]=4 [3]=6 [4]=8)

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

#check if the cells passed give us a winner
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

#finding a cell, which when played will make the player passed win the game
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

#to insert the specified symbol into the specified cell
function insert_in_the_cell(){
	local cellToInsertTheSymbol=$1
	local symbolToInsert=0
	if [ $2 == "user" ]
	then
		symbolToInsert=$PLAYER_SYMBOL
	else
		symbolToInsert=$COMPUTER_SYMBOL
	fi
	if [[ ${ticTacToeBoard[$cellToInsertTheSymbol]} =~ [0-9] ]]
	then
		ticTacToeBoard[$cellToInsertTheSymbol]=$symbolToInsert
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

#to check if the given symbol->($1) player can win the game in the next chance
function win_checker(){
	local chosenCellForWinCheck=1
	local winCell=0
	while [ $chosenCellForWinCheck -le $MAX_CELLS_AVAILABLE ]
	do
		if [[ ${ticTacToeBoard[$chosenCellForWinCheck]} =~ [1-9] ]]
		then
			winCell=$(check_win_possibility $chosenCellForWinCheck $1)
		fi
		if [ $winCell -gt 0 ]
		then
			echo $chosenCellForWinCheck
			return
		fi
		((chosenCellForWinCheck++))
	done
	echo 0
}

#checks if corner cells are available. if yes then returns a corner cell
function search_for_corner_cell_space(){
	for (( i=1 ; $i <= 4 ; i++ ))
	do
		index=${cornerCells[$i]}
		if [[ ${ticTacToeBoard[$index]} != $PLAYER_SYMBOL ]] && [[ ${ticTacToeBoard[$index]} != $COMPUTER_SYMBOL ]]
		then
			echo $index
			return
		fi
	done
	echo 0
}

#computer choses to play winning move first followed by a blocking move to 
#block the player from winning followed by playing on a corner cell
#followed by playing on the center cell else any other remaining cell
function computer_chance(){
	local ifCompCanWin=0
	local ifPlayerCanWin=0
	local playCornerCell=0
	if [ $1 -ge 4 ]
	then
		ifCompCanWin=$(win_checker $COMPUTER_SYMBOL)
		if [ $ifCompCanWin -gt 0 ]
		then
			echo $ifCompCanWin
			return
		fi
		ifPlayerCanWin=$(win_checker $PLAYER_SYMBOL)
		if [ $ifPlayerCanWin -gt 0 ]
		then
			echo $ifPlayerCanWin
			return
		fi
	fi
	playCornerCell=$(search_for_corner_cell_space )
	if [ $playCornerCell -ne 0 ]
	then
		echo $playCornerCell
		return
	elif [[ ${ticTacToeBoard[$CENTER_CELL]} != $PLAYER_SYMBOL && ${ticTacToeBoard[$CENTER_CELL]} != $COMPUTER_SYMBOL ]]
	then
		echo $CENTER_CELL
		return
	fi
	for (( i=1 ; $i<=4 ; i++ ))
	do
		local index=${sideCells[$i]}
		if [[ ${ticTacToeBoard[$index]} != $PLAYER_SYMBOL && ${ticTacToeBoard[$index]} != $COMPUTER_SYMBOL ]]
		then
			echo $index
			return
		fi
	done
}

#to give next chance to other player
function switch_player(){
	if [ $1 == "user" ]
	then
		echo "computer"
	else
		echo "user"
	fi
}

#tic-tac-toe game starts here
function the_main_exec_starts_here(){
	local isWinner=0
	local whoseChanceIsIt=0
	reset_the_board
	local whoseChanceIsIt=$( toss_to_decide_who_plays_first )
	chanceNumber=1
	while [ $chanceNumber -le $MAX_CELLS_AVAILABLE ]
	do
		local cellNumber=0
		display_the_board
		if [ $whoseChanceIsIt == "user" ]
		then
			echo "user chance"
			cellNumber=$(user_chance)
			insert_in_the_cell $cellNumber $whoseChanceIsIt
			isWinner=$(check_if_this_player_won $cellNumber)
		else
			echo "computer chance"
			cellNumber=$(computer_chance $chanceNumber)
			insert_in_the_cell $cellNumber $whoseChanceIsIt
			isWinner=$(check_if_this_player_won $cellNumber)
		fi
		if [ $isWinner -gt 0 ]
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

#main call
the_main_exec_starts_here
