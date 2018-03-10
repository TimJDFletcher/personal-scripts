#!/bin/bash
# createHDR.sh
# Version 1.2 (September 29 2009)
# Author: Vincent Tassy <photo@tassy.net>
# Site: http://photo-en.tassy.net
# This script is released under a CC-GNU GPL License

# A bash script to create an HDR image out of set of jpg or CR2 images
# Results in a Gimp xcf file containing 3 layers
#	an exposure blend of the original images using enfuse
#	a tone-mapped image using the mantiuk06 operator
#	a tone-mapped image using the fattal03 operator

# This script is based on the work of Edu Pérez - http://photoblog.edu-perez.com

# Changelog
#
# Version 1.0
#	first public release
# Version 1.1
#	- using pfsoutimgmagick instead of pfsout/pfsouttiff because they are broken in Fedora 11
# Version 1.2
#	- changed header to user /bin/bash instead of /bin/sh to avoid problems on ubuntu

SELF=`basename $0`	# Ouselve
DIR=""
ALIGN=0			# Don't align the images by default
QUIET=0			# not too quiet by default

displayHelp() {
	echo "Create an HDR picture out of a set of bracketed images."
	echo "Based on the work of Edu Pérez - http://photoblog.edu-perez.com"
	echo
	echo "Usage: $SELF [OPTION] DIR"
	echo -e "  --align -a\tAlign the pictures first"
	echo -e "  --quiet -q\tQuiet"
	echo -e "  --help  -h\tThis help"
	echo
	echo "Report bugs to <photo@tassy.net>"
}

# test params
while [ "$1" != "" ]; do
	case "$1" in
		"--help" | "-h")
			displayHelp
			exit
			;;
		"--align" | "-a")
			ALIGN=1
			;;
		"--quiet" | "-q")
			QUIET=1
			;;
		*)
			DIR=$1
			;;
	esac
	shift
done
if [ -z $DIR ]; then
	displayHelp
	exit
fi
if [ ! -d "$DIR" ]; then
	echo "$DIR is not a valid directory"
	displayHelp
	exit
fi
DIR=$(cd "$DIR" && pwd) #transform to absolute path
# Check of the directory contains only one type of files
if [ `find $DIR -maxdepth 1 -type f -exec basename {} \; | sed "s/.*\.//g" | tr '[:lower:]' '[:upper:]' | sort -u | wc -l` != 1 ]; then
	echo "Error: Directory contains multiple filetypes"
	exit
fi
FILES=(`find $DIR -maxdepth 1 -type f -print | sort`) # List files in the selected directory
filetype=`basename ${FILES[0]} | sed "s/.*\.//g" | tr '[:lower:]' '[:upper:]'` # Get file extension
if [ $filetype = "JPG" ] || [ $filetype = "CR2" ]; then
	if [ $QUIET = 0 ]; then
		echo "Files are $filetype"
		echo "Parsing EXIF information"
	fi
	if [ $filetype = "JPG" ]; then
		jpeg2hdrgen ${FILES[*]} > "$DIR"/pfs.hdrgen # Generate input file for pfstools
	else
		dcraw2hdrgen ${FILES[*]} > "$DIR"/pfs.hdrgen # Generate input file for pfstools
		if [ $QUIET = 0 ]; then
			echo "Devloping RAW files"
		fi
		ufraw-batch --wb=camera --gamma=0.45 --linearity=0.10 --exposure=0.0 --saturation=1.0 --out-type=tiff --out-depth=16 --overwrite ${FILES[*]}
		FILES=("$DIR"/*.tif)
	fi
	if [ $ALIGN = 1 ]; then
		if [ $QUIET = 0 ]; then
			echo "Aligning images"
		fi
		align_image_stack -a "$DIR"/AIS_ ${FILES[*]} >/dev/null
		FILES=("$DIR"/AIS_*.tif)
	fi
	if [ $QUIET = 0 ]; then
		echo "Generating Enfused image"
	fi
	enfuse -o "$DIR"/enfuse.tif ${FILES[*]} >/dev/null
	if [ $QUIET = 0 ]; then
		echo "Generating HDR"
	fi
	i=0
	cat "$DIR"/pfs.hdrgen | while read LINE; do
		echo "${FILES[$i]} $LINE" | cut -d' ' -f1,3- >> "$DIR"/pfs_updated.hdrgen # Keep meta-data but change files involved
		let "i = $i +1"
	done
	pfsinhdrgen "$DIR"/pfs_updated.hdrgen | pfsclamp --rgb | pfsout "$DIR"/pfs.hdr 2>/dev/null # Generate HDR image
	if [ $QUIET = 0 ]; then
		echo "Tone-mapping with mantiuk06 operator"
	fi
	pfsin "$DIR"/pfs.hdr | pfstmo_mantiuk06 -e 1 -s 1 2>/dev/null | pfsgamma --gamma 2.2 | pfsoutimgmagick "$DIR"/hdr_mantiuk06.tif >/dev/null 2>&1
	if [ $QUIET = 0 ]; then
		echo "Tone-mapping with fattal02 operator"
	fi
	pfsin "$DIR"/pfs.hdr | pfstmo_fattal02 -s 1 | pfsoutimgmagick "$DIR"/hdr_fattal02.tif 
	if [ $QUIET = 0 ]; then
		echo "Creating image stack"
	fi
	gimp -c -d -i -f -s -n -b \
		'(define (create-hdr-stack enfusefilename mantiukfilename fattalfilename targetfilename)
		(let* ((image (car (gimp-file-load RUN-NONINTERACTIVE enfusefilename enfusefilename)))
		(drawable (car (gimp-image-get-active-layer image)))
		(mantiuklayer (car (gimp-file-load-layer RUN-NONINTERACTIVE image mantiukfilename)))
		(fattallayer (car (gimp-file-load-layer RUN-NONINTERACTIVE image fattalfilename))))
		(gimp-image-add-layer image mantiuklayer -1)
		(gimp-layer-set-mode mantiuklayer SOFTLIGHT-MODE)
		(gimp-layer-set-opacity mantiuklayer 50.0)
		(gimp-image-add-layer image fattallayer -1)
		(gimp-layer-set-mode fattallayer OVERLAY-MODE)
		(gimp-xcf-save RUN-NONINTERACTIVE image fattallayer targetfilename targetfilename)
		(gimp-image-delete image)))

		(create-hdr-stack "'$DIR/enfuse.tif'" "'$DIR/hdr_mantiuk06.tif'" "'$DIR/hdr_fattal02.tif'" "'$DIR/hdr.xcf'")
		(gimp-quit 0)' >/dev/null 2>&1
	if [ $QUIET = 0 ]; then
		echo "Cleaning up"
	fi
	rm -f $DIR/AIS_*.tif $DIR/enfuse.tif $DIR/hdr_fattal02.tif $DIR/hdr_mantiuk06.tif $DIR/pfs.hdr $DIR/pfs.hdrgen $DIR/pfs_updated.hdrgen
else
	echo "Unsupported file type: $filetype"
fi
