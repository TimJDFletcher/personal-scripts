#/bin/sh
image='/Data/SparseBundles/Torrents.sparsebundle/'
hdiutil compact $image
hdiutil attach $image
