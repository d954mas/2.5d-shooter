#!/usr/bin/env sh
#Пересохранят все карты. Нужно при добавление новый тайлов
#cd ./Documents/development/journey-dev/hj_tools/hex_map


#resave tilesets
echo resave tilesets;
echo ""
/C/Program\ Files/Tiled/tiled.exe --export-map lua ./tilesets/tilesets.tmx ./tilesets/tilesets.lua

rm -rf ./lua/*
for f in $(find ./sources -name '*.tmx'); do
	fname=`basename $f`
	newname=${fname%.*}.lua
	echo $f;
	 /C/Program\ Files/Tiled/tiled.exe --export-map lua $f ./lua/$newname
done;

#read -p "Press any key to exit"
