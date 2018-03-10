#!/bin/sh
source=$1
target=$2
pictures="jpg png gif bmp"
movies="mpg mp4 m4v mkv flv avi mov 3gp"
documents="doc xls ppt pdf pub pptx xlsx docx wps csv"
audio="m4a mp3 wav"
archives="rar zip 7z"


for type in pictures archives movies documents audio ; do
	mkdir -p $target/$type
	for ext in $(eval echo \$$type) ; do
		find $source/recup_dir.* -type f -name \*.$ext -print0 | xargs -0 -I % ln % $target/$type
	done
done

exiftool -r '-FileName<CreateDate' -d $target/photos/%Y/%m/%d/%Y%m%d-%H%M.%%e $target/pictures

# /usr/share/fslint/fslint/findup -d $target -size +10k
