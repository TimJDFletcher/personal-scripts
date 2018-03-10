#!/bin/sh
ufraw-batch \
--out-path=/tmp \
--wb=camera \
--exposure=auto \
--restore=hsv \
--wavelet-denoising-threshold=.2 \
--interpolation=ahd \
--rotate=camera \
--out-type=jpg \
--exif $*

