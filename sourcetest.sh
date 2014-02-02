source ./utils/exists.sh

declare -A test1
test1[a_status]="aaa"
test1[b_status]="bbb"


if exists "a_status" in test1
then
    echo "exists"
fi
