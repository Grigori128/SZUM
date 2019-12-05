#!/bin/bash
cd control

printf "Prosty skrypt sterujący robotem Darwin\n\n"

while :
 do

printf "Proszę wybrać sekwencję: \n\n [0] - powrót do pozycji startowej \n [1] - ruch głową po okręgu \n [2] - imitacja ukłonu \n [3] - ruch torsu po elipsie \n [4] - znak ""tak"" \n [5] - znak ""nie"" \n [6] - jednoczesny ruch okrężny głowy i torsu robota \n [7] - wyjście\n\n"

	read type

	case $type in

		"0")
			printf "\nWykonuje: Reset pozycji"
			matlab -nodisplay -r 'RobotMotion(0);exit';;

		"1")
			printf "\nWykonuje: Ruch głową po okręgu"
			matlab -nodisplay -r 'RobotMotion(1);exit';;

		"2")
			printf "\nWykonuje: Imitacja ukłonu"
			matlab -nodisplay -r 'RobotMotion(2);exit';;

		"3")
			printf "\nWykonuje: Ruch torsu po elipsie"
			matlab -nodisplay -r 'RobotMotion(3);exit';;

		"4")
			printf "\nWykonuje: Znak ""tak"""
			matlab -nodisplay -r 'RobotMotion(4);exit';;

		"5")
			printf "\nWykonuje: Znak ""nie"""
			matlab -nodisplay -r 'RobotMotion(5);exit';;

		"6")
			printf "\nWykonuje: Jednoczesny ruch okrężny głowy i torsu robota"
			matlab -nodisplay -r 'RobotMotion(6);exit';;

		"7") 	exit;;
		
		*)	printf "\nBłędny wybór\n"
	esac

done

