#!/bin/sh
# Script to download all Astrix comics
# GPL2 blah
# Tim Fletcher <tim@night-shade.org.uk>

IFS="
"
baseurl=http://asterixonline.info/comics/mangas/Asterix%20Comics
target=/working/Asterix

for chapter in $(cat Asterix-chapters.txt| head -n53 ) ; do
	mkdir -p "$target/$chapter"
	cd "$target/$chapter"

	pagename="$(echo $chapter | cut -d " " -f 3-)"

	echo "Pattern 1"
	url="$baseurl/${chapter}/00- ${pagename}.jpg"
	echo $url ; wget --no-clobber "$url"
	for page in $(seq -w 1 70 ) ; do
		url="$baseurl/${chapter}/${page}- ${pagename}.jpg"
		echo $url
		if ! wget --no-clobber "$url" ; then break 1 ; fi
	done

	echo "Pattern 2"
	url="$baseurl/${chapter}/00- ${pagename}(00).jpg"
	echo $url ; wget --no-clobber "$url"
	for page in $(seq -w 1 70 ) ; do
		url="$baseurl/${chapter}/${page}- ${pagename}($(echo $page| sed -e s/^0//g)).jpg"
		echo $url
		if ! wget --no-clobber "$url" ; then break 1 ; fi
	done

	pagename="$(echo $chapter | sed -e 's/ - /- /g')"

	echo "Pattern 3"
	url="$baseurl/${chapter}/${pagename}(00).jpg"
	echo $url ; wget --no-clobber "$url"
	for page in $(seq -w 1 70 ) ; do
		url="$baseurl/${chapter}/${pagename}(${page}).jpg"
		echo $url
		if ! wget --no-clobber "$url" ; then break 1 ; fi
	done

	echo "Pattern 4"
	url="$baseurl/${chapter}/${pagename}(00).jpg"
	echo $url ; wget --no-clobber "$url"
	for page in $(seq 1 70 ) ; do
		url="$baseurl/${chapter}/${pagename}(${page}).jpg"
		echo $url
		if ! wget --no-clobber "$url" ; then break 1 ; fi
	done

done
