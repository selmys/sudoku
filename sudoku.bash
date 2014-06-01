#!/bin/bash
#
# A backtracking sudoku puzzle maker written in BASH 4 
# by
# John Selmys - April 2010 - Seneca College - Toronto
# 
declare -A grid
declare -i counter=0

function puzzle() {
   for r in 0 3 6;do
      for c in 0 3 6;do
         declare -a x=($(get9))
         for row in 0 1 2;do
            for col in 0 1 2;do
               ((R=row+r))
               ((C=col+c))
	       ((p=row*3+col+1))
               if [ $p -eq ${x[0]} -o $p -eq ${x[1]} -o $p -eq ${x[2]} -o $p -eq ${x[3]} ];then
                  grid[$R,$C]=' '
               fi
            done
         done
      done
   done
}

function init() {
   for row in 0 1 2 3 4 5 6 7 8;do
      for col in 0 1 2 3 4 5 6 7 8;do
         grid[$row,$col]=0
      done
   done
}

function get9() {
   declare -a n=(0 1 2 3 4 5 6 7 8 9)
   for l in 9 8 7 6 5 4 3 2 1;do
      ((r=$RANDOM%$l+1))
      A="$A "${n[$r]}
      n[$r]=${n[$l]}
   done
   echo -n $A
}

function available() {
   r=$1;c=$2;m=$3
   for col in 0 1 2 3 4 5 6 7 8;do
      if [ ${grid[$r,$col]} -eq $m ];then
         echo -n 0
         return
      fi
   done
   for row in 0 1 2 3 4 5 6 7 8;do
      if [ ${grid[$row,$c]} -eq $m ];then
         echo -n 0
         return
      fi
   done
   ((r=r/3*3))
   ((c=c/3*3))
   for row in 0 1 2;do
      for col in 0 1 2;do
         ((R=row+r))
         ((C=col+c))
         if [ ${grid[$R,$C]} -eq $m ];then
            echo -n 0
            return
         fi
      done
   done
   echo -n 1
} 

function generate() {
   row=$1
   col=$2
   if [ $row -gt 8 ];then
	show
	echo counter is $counter
	puzzle
	show
	exit
   fi 
   for m in $(get9);do
	((counter++))
	if [ $(available $row $col $m) -eq 1 ];then	
	   grid[$row,$col]=$m
   	   if [ $col -lt 8 ];then
	      generate $row $(expr $col + 1)
   	   else
              generate $(expr $row + 1) 0 
   	   fi
	fi
   done 
   if [ $col -gt 0 ];then
      ((col--))
   else
      col=8
      ((row--))
   fi      
   grid[$row,$col]=0
}

function show() {
   for row in 0 1 2 3 4 5 6 7 8;do
      if [ $row -eq 0 -o $row -eq 3 -o $row -eq 6 ];then
         echo '+-----+-----+-----+'
      fi
      for col in 0 1 2 3 4 5 6 7 8;do
         if [ $col -eq 0 -o $col -eq 3 -o $col -eq 6 ];then
            echo -n '|'
         else
	    echo -n ' '
         fi
         echo -n "${grid[$row,$col]}"
      done
      echo '|'
   done
   echo '+-----+-----+-----+'
}

init
generate 0 0 
