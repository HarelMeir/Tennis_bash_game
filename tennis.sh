#! /bin/bash
#Harel Meir 205588940

score1="50"		# score of player1.
score2="50"		# score of player2.
player_1_guess=""	# player1 number.
player_2_guess=""	# player2 number.
ballstatus=0		# ball status on  the board.
legal=1			# is the move legal.
winner=0		# who is the winner(0 no one, 1 ,2 ,3 is tie).
turn=0

findwinner () {
	case $winner in
	1)	echo "PLAYER 1 WINS !"	;;
	2)	echo "PLAYER 2 WINS !"	;;
	3)	echo "IT'S A DRAW !"	;;
	esac

}

printmoves () {
	echo -e "       Player 1 played: ${player_1_guess}\n       Player 2 played: ${player_2_guess}\n\n"
}

# is game over.
isgameover() {
	# if ball status is -3 / 3 -> over..
	if [ $ballstatus -eq 3 ] ; then
		winner=1
	elif [ $ballstatus -eq -3 ] ; then
		winner=2
	fi

        # if one player has 0 points, and the other player has non zero points.
	if [ $score1 -eq  0 -a $score2 -gt 0 ] ; then
		winner=2
	elif [ $score1 -gt 0 -a $score2 -eq 0 ] ; then
		winner=1
	elif [ $score1 -eq 0 -a $score2 -eq 0 ] ; then
		if [ $ballstatus -gt 0 ] ; then
			winner=1
		elif [ $ballstatus -lt 0 ] ; then
			winner=2
		else
			winner=3
		fi
	fi

}

#apply a move on the ball.
applymove() {
	# if player 1 wins -> ballstatus++
	if [ $player_1_guess -gt $player_2_guess ] ; then
		if [ $ballstatus -le 0 ] ; then
			ballstatus=1
		else
			ballstatus=$[$ballstatus+1]
		fi
	# if player2 wins -> ballstatus--
	elif [ $player_1_guess -lt $player_2_guess ] ; then
		if [ $ballstatus -ge 0 ] ; then
			ballstatus=-1
		else
			ballstatus=$[$ballstatus-1]
		fi
	fi

	if [ $score1 -eq 0 -o $score2 -eq 0 -o $ballstatus -eq 3 -o  $ballstatus -eq -3 ] ; then
		isgameover
	fi
}


# check if the number is correct
islegal() {
	# check if the number is between 0 - 50.
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]] ; then
   		echo "NOT A VALID MOVE !"
		return
	fi

	# checks if the number is in legal range.
	temp=$[$2 - $1]
	if [[ $temp -ge 0 ]]
	then
		legal=0
		return $temp
	else
		echo "NOT A VALID MOVE !"
	fi

	# check if the number isnt bigger than current score.
		# no -> print an error message.
		# ask for a number again.
}

# print the middle
printmiddle() {
	#print the new middle using switch case.
	case $ballstatus in
		0) echo " |       |       O       |       | "
		;;
		1) echo " |       |       #   O   |       | "
		;;
		2) echo " |       |       #       |   O   | "
		;;
		3) echo " |       |       #       |       |O"
		;;
		-1) echo " |       |   O   #       |       | "
		;;
		-2) echo " |   O   |       #       |       | "
		;;
		-3) echo "O|       |       #       |       | "
		;;
	esac
}


# this method prints the board
printboard() {
	echo " Player 1: ${score1}         Player 2: ${score2} "
        echo " --------------------------------- "
        echo " |       |       #       |       | "
        echo " |       |       #       |       | "
        printmiddle
        echo " |       |       #       |       | "
        echo " |       |       #       |       | "
        echo " --------------------------------- "
	if [ $turn -gt 0 ] ; then
		printmoves
	fi
}

# pick and handle players numbers.
picknumbers() {
	# player 1 pick a number.

	while [ $legal -eq "1" ]
	do
		echo "PLAYER 1 PICK A NUMBER: "
		read -s player_1_guess
		islegal $player_1_guess $score1
	done
	legal=1
	score1=$temp

	# player 2 pick a number.

	while [ $legal -eq "1" ]
	do
		echo "PLAYER 2 PICK A NUMBER: "
		read -s player_2_guess
		islegal $player_2_guess $score2
	done
	legal=1
	score2=$temp
}


gameloop () {
	while [ $winner -eq 0 ]
	do
		picknumbers
		applymove
		printboard
	done

	findwinner
}

printboard
turn=1
gameloop
