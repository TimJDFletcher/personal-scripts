#!/bin/sh
exiftool -ImageDescription -Make -Model -Artist -WhitePoint -Copyright -GPS:all -DateTimeOriginal -CreateDate -UserComment -ColorSpace -OwnerName -SerialNumber -overwrite_original_in_place -TagsFromFile "$1" "$2"
