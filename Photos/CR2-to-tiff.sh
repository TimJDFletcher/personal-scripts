#!/bin/sh
process()
{
dcraw -T -w -q 3 -n 333 $1
basename=$(echo $1 | sed -e s/\.CR2\$//g -e s/\.cr2\$//g)
exiftool -ImageDescriptin -Make -Model -Artist -WhitePoint -Copyright -GPS:all -DateTimeOriginal -CreateDate -UserComment -ColorSpace -OwnerName -SerialNumber -overwrite_original_in_place -TagsFromFile $1 $basename.tiff 
}

for file in $(find ./ -maxdepth 1 -iname \*.cr2 ) ; do
	process $file
done
