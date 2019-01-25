#!/bin/bash

### Nick Everett 2018 ###

#Set your options here:
file_ext='.jpg'   #.jpg/.cdl/.ccc etc
files_source=/here/are/my/files   #where stills are to be extracted from before sorting
files_dest=/here/willbe/my/files  #Where the extracted stills are stored temporarily before being sorted
naming_regex=''   #write regex here based on still naming convention

##This section extracts all stills from given folder (stills_source), recursively and copies all to new folder (stills_dest)##
#cd "$stills_source"
#find . -iname \*.jpg -exec file {} \; | cut -d':' -f1 | xargs -I{} cp -v {} "$stills_dest"

##This section sorts extracted stills and moves them into sorted folders##
cd "$files_dest"

for f in *.jpg; do

    filename=${f%.*} #filename without extension
    regex='^(VX|V|X)?[0-9]{1,2}-[0-9A-Z]{1,4}-[0-9]{2}\([a-z]\)'
    
    #if to check file name matches convention
    if [[ $filename =~ $regex ]]; then
        scene=$(echo $filename | grep -o -e '-[A-Z]*[0-9][0-9]' | head -1 | sed 's/-[A-Z]*//') # extract scene number
        ep=$(echo $filename| grep -o -e '[1-9]\|1[0-2]' | head -1 | sed 's/-$//') #extract ep number
            if [ $ep -le 9 ]; then #add zero to ep number if <= 9
                ep=0$ep
            fi

    else
        ep="UNKNOWN"
        scene="UNKNOWN"
    fi
    
    echo $filename "-" $ep $scene # print filename next to ep-scene for troubleshooting
    
    dir="./S01E$ep/$ep$scene" # new sort dir name # set dir name based on extracted info
    dir_dup="./Duplicates"
    
    mkdir -p "$dir"	# make new dirs
    mkdir -p "$dir_dup"
    
    if [[ ! -f "./S01E$ep/$ep$scene/$f" ]]; then #if file does not exist in dir, then move
    	mv "$f" "$dir"
        echo "Copying file to ./S01E$ep/$ep$scene/$f"
    else
    	mv "$f" "$dir_dup"
        echo "File already exists in destination - ./S01E$ep/$ep$scene/$f"

    fi

done