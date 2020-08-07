#!/bin/bash

VV(){ #사용할 variables
dNum=`ls -l | cut -d " " -f1 | grep 'd' | wc -l` #총 디렉토리 개수

zip_Num=`ls | rev | grep 'piz.' | wc -l`
tar_Num=`ls | rev | grep 'rat.' | wc -l`
gz_Num=`ls | rev | grep 'zg.' | wc -l`
exe_Num=`ls -F | grep '*$' | wc -l`
SNum=`expr $zip_Num + $tar_Num + $gz_Num + $exe_Num`
fNum=`ls -l | cut -c 1 | grep '-' | wc -l` #총 파일 개수
NNum=`expr $fNum - $SNum`

aNum=`expr $dNum + $fNum`
}

Shape(){
clear
tput cup 0 0
echo "================================================ 2016603009 HaYoung Moon ==============================================="
echo "========================================================= List ========================================================="
tput cup 2 0
row=2
while [ $row -le 29 ]
do
        for col in 0 30 80 119
        do
                tput cup $row $col
                echo "|"
        done
        row=`expr $row + 1`
done
tput cup 30 0
echo "====================================================== Information ====================================================="
row2=31
while [ $row2 -le 36 ]
do
        for col in 0 119
        do
                tput cup $row2 $col
                echo "|"
        done
        row2=`expr $row2 + 1`
done
tput cup 37 0
echo "========================================================= Total ========================================================"
for col in 0 119
do
        tput cup 38 $col
        echo "|"
done
tput cup 39 0
echo "========================================================== END ========================================================="
}


List1(){
VV
declare -i i=1

tput cup 2 1
if [ $cursor = 2 ] && [ $section = 1 ]
then
	tput rev
	echo -e "\e[31m".."\e[m" #빨간색
	tput sgr0
else
	echo -e "\e[31m".."\e[m" #빨간색
fi
index[0]=".."

for A in *
do
	if [ $i -le 27 ]
	then
		tput cup `expr $i + 2` 1
		if [ -d $A ]
		then
			if [ $cursor = `expr $i + 2` ] && [ $section = 1 ]
			then
				tput rev
				if [ $A = "2016603009-TrashBin" ]
				then
					echo -e "\e[33m$A\e[m" #노란색
				else
					echo -e "\e[34m$A\e[m" | cut -b -28 #파란색
				fi
				tput sgr0
			else
                        	if [ $A = "2016603009-TrashBin" ]
                                then
                                        echo -e "\e[33m$A\e[m" #노란색
                                else
                                        echo -e "\e[34m$A\e[m" | cut -b -28 #파란색
                                fi
			fi
		elif [ -f $A ]
		then
	                fInfox=`ls -l $A | cut -c 10` #실행 파일 찾기
	                fInfoz=`echo $A | rev | cut -d "." -f1 | rev` #압축 파일 찾기
			if [ $cursor = `expr $i + 2` ] && [ $section = 1 ]
			then
				tput rev
				if [ "$fInfox" = "x" ]
				then
					echo -e "\e[32m$A\e[m" | cut -b -28 #초록색
				else
					if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                                        then
                                                echo -e "\e[31m$A\e[m" | cut -b -28 #빨간색
                                        else
                                                echo -e "$A" | cut -b -28 #기본색
                                        fi
				fi
				tput sgr0
			else
				if [ "$fInfox" = "x" ] 
                                then
        	                        echo -e "\e[32m$A\e[m" | cut -b -28 #초록색
                                else
                                        if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                                        then
                                                echo -e "\e[31m$A\e[m" | cut -b -28 #빨간색
                                        else
                                                echo -e "$A" | cut -b -28 #기본색
                                        fi
                                fi
			fi
		fi
		index[$i]="$A"
		i=`expr $i + 1`
	else
		break
	fi
done
}

Information(){
i=`expr $cursor - 2`

fInfox=`ls -l ${index[$i]} | cut -c 10` #실행 파일 찾기
fInfoz=`echo ${index[$i]} | rev | cut -d "." -f1 | rev` #압축 파일 찾기

tput cup 31 1
echo "File name: ${index[$i]}" | cut -b -117
tput cup 32 1
if [ -d ${index[$i]} ]
then
	echo -e "File type: \e[34m"Directory"\e[m" #파란색
elif [ -f ${index[$i]} ]
then
	if [ $fInfox = "x" ]
        then
        	echo -e "File type: \e[32m"Execute file"\e[m" #초록색
        else
                if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                then
                	echo -e "File type: \e[31m"Compressed file"\e[m" #빨간색
                else
                	echo -e "File type: Normal file" #기본색
                fi
	fi
fi
tput cup 33 1
size=`du -sh ${index[$i]} | cut -f1`
echo "File size: $size"

tput cup 34 1
time=`stat -c %x ${index[$i]} | cut -d "." -f1`
echo "Access time: `date -d "$time" '+%b %d %T %Y'`"

tput cup 35 1
echo "Permission: `stat -c %a ${index[$i]}`"
tput cup 36 1
echo "Absolute path: $PWD/${index[$i]}" | cut -b -117
}

Total(){
VV

if [ -s "2016603009-TrashBin" ]
then
	total=`expr $aNum - 1`
	Dir=`expr $dNum - 1`
else
	total=`expr $aNum`
	Dir=`expr $dNum`
fi
size=`du -sh | cut -d " " -f1`

tput cup 38 25
echo "Total: $total, Directory: $Dir, SFile: $SNum, NFile: $NNum, Size: $size"
}

List2(){ #파일 내용 출력
i=`expr $cursor - 2`
line=`cat ${index[$i]} | wc -l`

if [ $line -ge 29 ]
then
	row=1
	while [ $row -le 27 ]
	do
		j=`expr 30 - $row`
		cat_f=`cat -T ${index[$i]} | tail -$j | head -1`
		tput cup `expr $row + 1` 32
		echo "$row $cat_f" | cut -b -48
		row=`expr $row + 1`
	done
	tput cup 29 30
	echo "..."
	tput sgr0
else
	row=1
        while [ $row -le $line ]
        do
                j=`expr $line - $row + 1`
                cat_f=`cat -T ${index[$i]} | tail -$j | head -1`
                tput cup `expr $row + 1` 32
                echo "$row $cat_f" | cut -b -48
                row=`expr $row + 1`
        done
	tput sgr0
fi
}

Tree(){
i=`expr $location - 2`
declare -i line=1

t[0]="${index[$i]}"

tput cup `expr $line + 1` 81
echo "- "
tput cup `expr $line + 1` 83
if [ $cursor = `expr $line + 1` ] && [ $section = 5 ]
then
	tput rev
	if [ "${t[0]}" = "2016603009-TrashBin" ]
	then
		echo -e "\e[33m${t[0]}\e[m" | cut -b -37
	else
		echo -e "\e[34m${t[0]}\e[m" | cut -b -37
	fi
	tput sgr0
else
	if [ "${t[0]}" = "2016603009-TrashBin" ]
        then
                echo -e "\e[33m${t[0]}\e[m" | cut -b -37
        else
                echo -e "\e[34m${t[0]}\e[m" | cut -b -37
        fi
fi

if [ $line -le 28 ]
then
	cd ${t[0]}
	for A in *
	do
		if [ -d $A ]
		then
			line=`expr $line + 1`
			tput cup `expr $line + 1` 81
			echo ".... - "
			tput cup `expr $line + 1` 88
			if [ $cursor = `expr $line + 1` ] && [ $section = 5 ]
			then
				tput rev
				echo -e "\e[34m$A\e[m" | cut -b -29 #파란색
				tput sgr0
			else
				echo -e "\e[34m$A\e[m" | cut -b -29 #파란색
			fi
			cd $A
			for B in *
			do
				if [ -d $B ]
				then
					line=`expr $line + 1`
		                        tput cup `expr $line + 1` 81
					echo "........ - "
					tput cup `expr $line + 1` 92
                        		if [ $cursor = `expr $line + 1` ] && [ $section = 5 ]
                       		 	then
                                		tput rev
                                		echo -e "\e[34m$B\e[m" | cut -b -25 #파란색
                                		tput sgr0
                        		else
                                		echo -e "\e[34m$B\e[m" | cut -b -25 #파란색
                        		fi
					cd $B
					for C in *
					do
						if [ -d $C ]
						then
							line=`expr $line + 1`
                        				tput cup `expr $line + 1` 81
							echo "............ - "
							tput cup `expr $line + 1` 96
	        			                if [ $cursor = `expr $line + 1` ] && [ $section = 5 ]
			        	                then
				                                tput rev
                                				echo -e "\e[34m$C\e[m" | cut -b -21 #파란색
                                				tput sgr0
                        				else
                                				echo -e "\e[34m$C\e[m" | cut -b -21 #파란색
                        				fi
							cd $C
							for D in *
							do
								if [ -d $D ]
								then
									line=`expr $line + 1`
									tput cup `expr $line + 1` 81
									echo "................ - "
									tput cup `expr $line + 1` 100
						                        if [ $cursor = `expr $line + 1` ] && [ $section = 5 ]
                                                        		then
                                                                		tput rev
                                                                		echo -e "\e[34m$D\e[m" | cut -b -17 #파란색
                                                                		tput sgr0
                                                        		else
                                                                		echo -e "\e[34m$D\e[m" | cut -b -17 #파란색
                                                        		fi
								elif [ -f $D ]
								then
									line=`expr $line + 1`
                                        				fInfox=`ls -l $D | cut -c 10` #실행 파일 찾기
                                        				fInfoz=`echo $D | rev | cut -d "." -f1 | rev` #압축 파일 찾기
                                        				tput cup `expr $line + 1` 81
									echo "................ "
									tput cup `expr $line + 1` 98
				                                        if [ $cursor = `expr $line + 1` ] && [ $section = 5 ]
                                				        then
                                                				tput rev
                                                				if [ "$fInfox" = "x" ]
                                                				then
                                                        				echo -e "\e[32m$D\e[m" | cut -b -19 #초록색
                                                				else
                                                        				if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                                                        				then
                                                                				echo -e "\e[31m$D\e[m" | cut -b -19 #빨간색
                                                        				else
                                                                				echo -e "$D" | cut -b -19 #기본색
                                                        				fi
                                                				fi
                                                				tput sgr0
                                        				else
                                                				if [ "$fInfox" = "x" ]
                                                				then
                                                        				echo -e "\e[32m$D\e[m" | cut -b -19 #초록색
                                                				else
                                                        				if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                                                        				then
                                                                				echo -e "\e[31m$D\e[m" | cut -b -19 #빨간색
                                                        				else
                                                                				echo -e "$D" | cut -b -19 #기본색
                                                        				fi
                                                				fi
                                        				fi
								fi
							done
							cd ../
						elif [ -f $C ]
						then
							line=`expr $line + 1`
                                        		fInfox=`ls -l $C | cut -c 10` #실행 파일 찾기
                                        		fInfoz=`echo $C | rev | cut -d "." -f1 | rev` #압축 파일 찾기
                                        		tput cup `expr $line + 1` 81
							echo "............ "
							tput cup `expr $line + 1` 94
                                        		if [ $cursor = `expr $line + 1` ] && [ $section = 5 ]
                                        		then
                                                		tput rev
                                                		if [ "$fInfox" = "x" ]
                                                		then
                                                        		echo -e "\e[32m$C\e[m" | cut -b -23 #초록색
                                                		else
                                                        		if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                                                        		then
                                                                		echo -e "\e[31m$C\e[m" | cut -b -23 #빨간색
                                                        		else
                                                                		echo -e "$C" | cut -b -23 #기본색
                                                        		fi
                                                		fi
                                                		tput sgr0
                                        		else
                                                		if [ "$fInfox" = "x" ]
                                                		then
                                                        		echo -e "\e[32m$C\e[m" | cut -b -23 #초록색
                                                		else
                                                        		if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                                                        		then
                                                                		echo -e "\e[31m$C\e[m" | cut -b -23 #빨간색
                                                        		else
                                                                		echo -e "$C" | cut -b -23 #기본색
                                                        		fi
                                                		fi
                                        		fi
						fi
					done
					cd ../
				elif [ -f $B ]
				then
					line=`expr $line + 1`
                        		fInfox=`ls -l $B | cut -c 10` #실행 파일 찾기
		                        fInfoz=`echo $B | rev | cut -d "." -f1 | rev` #압축 파일 찾기
                		        tput cup `expr $line + 1` 81
					echo "........ "
					tput cup `expr $line + 1` 90
                        		if [ $cursor = `expr $line + 1` ] && [ $section = 5 ]
              			        then
                                		tput rev
                                		if [ "$fInfox" = "x" ]
                                		then
                                        		echo -e "\e[32m$B\e[m" | cut -b -27 #초록색
                                		else
                                        		if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                                        		then
                                                		echo -e "\e[31m$B\e[m" | cut -b -27 #빨간색
                                        		else
                                                		echo -e "$B" | cut -b -27 #기본색
                                        		fi
                                		fi
                                		tput sgr0
                        		else
                                		if [ "$fInfox" = "x" ]
                                		then
                                        		echo -e "\e[32m$B\e[m" | cut -b -27 #초록색
                                		else
                                        		if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                        	                	then
                                	                	echo -e "\e[31m$B\e[m" | cut -b -27 #빨간색
                                        		else
                                                		echo -e "$B" | cut -b -27 #기본색
                                        		fi
                                		fi
                        		fi
				fi
			done
			cd ../
		elif [ -f $A ]
		then
			line=`expr $line + 1`
			fInfox=`ls -l $A | cut -c 10` #실행 파일 찾기
                        fInfoz=`echo $A | rev | cut -d "." -f1 | rev` #압축 파일 찾기
			tput cup `expr $line + 1` 81
			echo ".... "
			tput cup `expr $line + 1` 86
			if [ $cursor = `expr $line + 1` ] && [ $section = 5 ]
                        then
				tput rev
				if [ "$fInfox" = "x" ]
				then
					echo -e "\e[32m$A\e[m" | cut -b -31 #초록색
				else
					if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
					then
						echo -e "\e[31m$A\e[m" | cut -b -31 #빨간색
					else
						echo -e "$A" | cut -b -31 #기본색
					fi
				fi
				tput sgr0
			else
				if [ "$fInfox" = "x" ]
                                then
                                        echo -e "\e[32m$A\e[m" | cut -b -31 #초록색
                                else
                                        if [ "$fInfoz" = "zip" ] || [ "$fInfoz" = "tar" ] || [ "$fInfoz" = "gz" ]
                                        then
                                                echo -e "\e[31m$A\e[m" | cut -b -31 #빨간색
                                        else
                                                echo -e "$A" | cut -b -31 #기본색
                                        fi
                                fi
			fi
		fi
	done
fi
cd ../
tline=`expr $line`
}

Delete(){
k=`expr $cursor - 2`
pwd="$PWD" #경로 저장
name=${index[$k]} #파일명

dm=`ls -R $name | grep "$name/" | wc -l` #depth 1의 디렉토리 제외한 하위 디렉토리 수
dir[0]="$name"
mkdir $pwd/2016603009-TrashBin/${dir[0]}
declare -i i=1

while [ $i -le $dm ] #하위 디렉토리 만들기
do
	name2=`ls -R $name | grep "${dir[0]}/" | cut -d ":" -f1 | head -$i | tail -1`
	dir[$i]="$name2"
	mkdir $pwd/2016603009-TrashBin/${dir[$i]}
	i=`expr $i + 1`
done

declare -i j=0
while [ $j -le $dm ]
do
	cd $pwd/${dir[$j]}
	for A in *
	do
		if [ -f $A ]
		then
			fInfox=`ls -l $A | cut -c 10` #실행 파일 찾기 
			if [ $fInfox = "x" ]
        		then
				cat $A > $pwd/2016603009-TrashBin/${dir[$j]}/$A
				permission=`stat -c %a $A`
				chmod "$permission" $pwd/2016603009-TrashBin/${dir[$j]}/$A
        		else
                        		cat $A > $pwd/2016603009-TrashBin/${dir[$j]}/$A
        		fi
		fi
	done
	j=`expr $j + 1`
done

cd $pwd

rm -rf $name
}

Move(){
IFS= # distinguish " " "\t" from "\n"

VV
while [ 1 ]
do
	read -sn 1 key
	if [ "$key" = '' ]
	then
		read -sn 1 key
		read -sn 1 key
		if [ "$key" = 'A' ]
		then
			if [ $cursor -ge 3 ]
			then
				cursor=`expr $cursor - 1`
				Print
			fi
		elif [ "$key" = 'B' ]
		then
			if [ $cursor -le 28 ] && [ $cursor -le `expr $aNum + 1` ]
			then
				cursor=`expr $cursor + 1`
				Print
			fi
		fi
	elif [ "$key" = "" ]
	then
		if [ -d ${index[`expr $cursor - 2`]} ]
	        then
			a=`expr $cursor - 2`
			cd ${index[$a]}
             	        cursor=2
			section=1
                   	Print
               	elif [ -f ${index[`expr $cursor - 2`]} ]
               	then
                     	List2                   
               	fi
	elif [ "$key" = "t" ]
	then
		if [ -d ${index[`expr $cursor - 2`]} ]
		then
			location=`expr $cursor`
			cursor=2
			section=5
			Print2
			while [ 1 ]
			do
				read -sn 1 key2
				if [ "$key2" = '' ]
				then
					read -sn 1 key2
					read -sn 1 key2
					if [ "$key2" = 'A' ]
					then
						if [ $cursor -ge 3 ]
						then
							cursor=`expr $cursor - 1`
							Print2
						fi
					elif [ "$key2" = 'B' ]
					then
						if [ $cursor -le 28 ] && [ $cursor -le `expr $tline + 1` ]
						then
							cursor=`expr $cursor + 1`
							Print2
						fi
					fi
				elif [ "$key2" = "r" ]
				then
					break
				else
					continue
				fi
			done
			cursor=`expr $location`
			section=1	
			Print	
		fi
	elif [ "$key" = "d" ]
	then
		if [ $section = 1 ]
		then
			check=`pwd | rev | cut -d "/" -f1 | rev | grep "2016603009-TrashBin"`
			if [ "$check" = "2016603009-TrashBin" ]
			then
				a=`expr $cursor - 2`
				rm -rf ${index[$a]} #완전 삭제
			else
				check2=`pwd 2016603009-TrashBin`
				if [ $PWD = "$check2" ]
				then
					Delete
				fi
			fi
		fi
		Print
	else
		continue
	fi
done
}

Print(){
Shape
List1
Information
Total
}

Print2(){
Shape
List1
Information
Total
Tree
}

#탐색기 구현
cd
mkdir 2016603009-TrashBin
cursor=2 #커서 이동 (2번째 행부터 움직임)
section=1 #커서 이동 (섹션 구분)
location=3
tline=0
Print
Move
