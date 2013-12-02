#!/bin/bash

gui=1
dirr=$(zenity --file-selection --directory) 
$PWD/tubecrpt.sh $gui $dirr
notify-send "Done"
