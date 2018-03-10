add_ubootenv() {
	local dev=$1
	local offset=$2
	local envsize=$3
	local secsize=$4
	local numsec=$5
uci batch <<EOF
add ubootenv ubootenv
set ubootenv.@ubootenv[-1].dev='$dev'
set ubootenv.@ubootenv[-1].offset='$offset'
set ubootenv.@ubootenv[-1].envsize='$envsize'
set ubootenv.@ubootenv[-1].secsize='$secsize'
set ubootenv.@ubootenv[-1].numsec='$numsec'
EOF
}

# MTD device name	Device offset	Env. size	Flash sector size
add_ubootenv /dev/mtd0 0x0 0x10000 0x20000

uci commit ubootenv
