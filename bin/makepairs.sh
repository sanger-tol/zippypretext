outlog=$1
alignment=$2

version='1.0.0'
if [ $1 == '-v'];
then
    echo "$version"
else
    (cat $outlog | grep PRE_C_SIZE | awk '{print $2"\t"$3}' | awk 'BEGIN{print "## pairs format v1.0"} {print "#chromsize:\t"$1"\t"$2} END{print "#columns:\treadID\tchr1\tpos1\tchr2\tpos2\tstrand1\tstrand2"}'; cat $alignment) | gzip
fi
