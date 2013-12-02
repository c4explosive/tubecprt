#!/bin/bash

#########################
#IXT=input		#
#OUXT=output		#
#IX=input+ext		#
#OX=output+ext		#
#########################
#Functions#
###########
#*Cuidado con la cantidad del build y del resultado.
##$FFMPEG -y -vn -i $IXT  -acodec libmp3lame -ac 2 -ar 44100 -ab 256k -f mp3 -map_meta_data $OUXT:$IXT $OUXT
##$FFMPEG -y -i $IXT -f 3gp -vcodec h263 -s qcif -r 15 -b 160k -acodec libfaac -ac 2 -ar 32000 -ab 64k -map_meta_data $OUXT:$IXT $OUXT
#ffmpeg de mmc
FFMPEG="/opt/MIKSOFT/MobileMediaConverter/lib/ffmpeg"
#######################################################################################################################################################################
list=0
i=0
function download {
	if [ $list == 0 ]; then
		youtube-dl $1 -o $2
	else
		list=$(cat $1)
		for track in $list
		do
		youtube-dl $track -o $2"$i"
		i=$(expr $i \+ 1)
		done
		h=$i
	fi
}

function mp3 {
	mkdir mp3
	if [ $list == 0 ]; then
		IXT=$PWD/$2
		OUXT=$PWD/mp3/$2".mp3"
		$FFMPEG -y -vn -i $IXT  -acodec libmp3lame -ac 2 -ar 44100 -ab 256k -f mp3 -map_meta_data $OUXT:$IXT $OUXT
	else
		for ((i=0;i<$h;i++)) 
		do
			IXT=$PWD/$2$i
			OUXT=$PWD/mp3/$2$i".mp3"
			$FFMPEG -y -vn -i $IXT  -acodec libmp3lame -ac 2 -ar 44100 -ab 256k -f mp3 -map_meta_data $OUXT:$IXT $OUXT
		done
	fi
}
function 3gp {
	mkdir 3gp
	if [ $list == 0 ]; then
		IXT=$PWD/$2
		OUXT=$PWD/3gp/$2".3gp"
		$FFMPEG -y -i $IXT -f 3gp -vcodec h263 -s qcif -r 15 -b 160k -acodec libfaac -ac 2 -ar 32000 -ab 64k -map_meta_data $OUXT:$IXT $OUXT
	else
		for ((i=0;i<$h;i++))
		do
			IXT=$PWD/$2$i
			OUXT=$PWD/3gp/$2$i".3gp"
			$FFMPEG -y -i $IXT -f 3gp -vcodec h263 -s qcif -r 15 -b 160k -acodec libfaac -ac 2 -ar 32000 -ab 64k -map_meta_data $OUXT:$IXT $OUXT
		done
	fi
}
#######################################################################################################################################################################
#Commandd#
##########
function commandd {
	if [ $3 == 1 ]; then
		notify-send "Downloading..."
		download $1 $2
		notify-send "Converting..."
		mp3 $1 $2
		notify-send "Done"
	elif [ $3 == 2 ]; then
		notify-send "Downloading..."
		download $1 $2
		notify-send "Converting..."
		3gp $1 $2
		notify-send "Done"
	elif [ $3 == 3 ]; then
		list=1
		if [ $4 == 1 ]; then
			notify-send "Downloading..."
			download $1 $2
			notify-send "Converting..."
			mp3 $1 $2
			notify-send "Done"
		elif [ $4 == 2 ]; then
			notify-send "Downloading..."
			download $1 $2
			notify-send "Converting..."
			3gp $1 $2 
			notify-send "Done"
		else
			notify-send "Downloading..."
			download $1 $2
			notify-send "Done"
		fi
	elif [ $3 == "-h" ]; then
		echo -e "\e[23mSyntax: \e[34mtubecrpt.sh url\e[31m[or list] \e[34mname options \e[31m[list options]"
	        echo -e "\e[34mOptions: 1: for mp3; 2: for 3gp; 3: for download list; 3 1: list in mp3; 3 2: list in 3gp"
	else
		echo -e "\e[23mSyntax: \e[34mtubecrpt.sh url\e[31m[or list] \e[34mname options \e[31m[list options]"
	        echo -e "\e[34mOptions: 1: for mp3; 2: for 3gp; 3: for download list; 3 1: list in mp3; 3 2: list in 3gp"
	fi
}
#####
#GUI#
#####
function gui {
item=$(zenity --entry --title="tubecrpt" --text="Url or file:" 2>/dev/null)
it=${item:0:4}
name=$(zenity --entry --title="tubecrpt" --text="Name:" 2>/dev/null)
if [ $it == "http" ]; then
	format=$(zenity --list --title="tubecrpt" --column="Format:" "mp3" "3gp" 2>/dev/null)
	if [ $format == "mp3" ]; then
		download $item $name
		mp3 $it $name
	else
		download $item $name
		3gp $it $name
	fi
else
	list=1
	format=$(zenity --list --title="tubecrpt" --column="Format:" "Download" "mp3" "3gp" 2>/dev/null)
	echo $format
	if [ $format == "Download" ]; then
		download $item $name
	elif [ $format == "mp3" ]; then
		download $item $name
		mp3 $it $name
	else
		download $item $name
		3gp $it $name
	fi
fi
}
#######################################################################################################################################################################
#GUI or Command#
################

#Activador Gui
if [ $1 == "1" ]; then
	cd $2
        gui
else
        commandd $1 $2 $3 $4
fi

