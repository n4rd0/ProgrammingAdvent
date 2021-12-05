#Simple script that copies all the problems from
#one directory to another, keeping the day structure
#TODO: allow for multiple files for the same day
#Run within the directory containing the files
CURR_DIR_PREFIX="Dia"
TRGT_DIR_PREFIX="D"
NAME="file.py"
YEAR="2021"

TARGET="../ProgramingAdvent/AoC$YEAR"
LEN=$(expr length $CURR_DIR_PREFIX)

for DIR in ./*; do
    if [ -d $DIR ]; then
        NUM=$(echo $DIR | cut -b $(($LEN+1+2)),$(($LEN+2+2)))

        if [ -f "$DIR/$NAME" ]; then
            mkdir "$TARGET/$TRGT_DIR_PREFIX$NUM" &>/dev/null
            if [ -f "$TARGET/$TRGT_DIR_PREFIX$NUM/$NAME" ]; then
                echo "Day $NUM updated"
            else
                echo "Day $NUM added"
            fi

            cp -u "$DIR/$NAME" "$TARGET/$TRGT_DIR_PREFIX$NUM/$NAME"
            if [ $? -ne "0" ]; then
                echo "Problem cp Day $NUM"
            fi
        fi
    fi
done
