#!/bin/bash

# Flags handler
PNG=false
DPI="96"
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "TikzCleaner -- Improve user experience with Tikz"
      echo " "
      echo "Options:"
      echo "-h, --help: get this help"
      echo "-p, --png: will produce also a png after compilation"
      echo "--dpi [value]: change the value of dpi for the png. Default = 96"
      echo " "
      exit 0
      ;;
    -p|--png)
      PNG=true
      shift
      ;;
    --dpi)
      shift
      if test $# -gt 0; then
        re='^[0-9]+$'
        if ! [[ $1 =~ $re ]] ; then
          echo "DPI is not a number" >&2; exit 1
        fi
        DPI=$1
      else
        echo "No DPI provided"
        exit 1 
      fi
      shift
      ;;
    *)
      echo "Unknown flag: "${1}
      exit 1
      ;;
  esac
done

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SOURCE_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
DIR=$(pwd)

find_tikz () {
  FILE_TO_VISIT=()
  while IFS=  read -r -d $'\0'; do
    FILE_TO_VISIT+=("$REPLY")
  done < <(find $1 -maxdepth 1 -name "*.tex" -print0)

  for file in ${FILE_TO_VISIT[@]}; do
    echo ${file}
    BEGIN=($(grep -n "begin{tikzpicture}" ${file} | cut -f1 -d:))
    END=($(grep -n "end{tikzpicture}" ${file} | cut -f1 -d:))
    if [ ${#BEGIN[@]} -ne ${#END[@]} ]
    then
      echo "Not the same number of \\begin{tikzpicture} (${#BEGIN[@]}) and \\end{tikzpicture} (${#END[@]}) in ${file}. File will be ignored"
    else
      mkdir -p ${1}tikz
      for i in $(seq $((${#BEGIN[@]} - 1)) -1 0); do
        IFS=$'\n'
        VAL=($(sed -n "${BEGIN[i]},${END[i]}p" ${file})) 
        tmp=($(find ${1}tikz/*.tex 2>/dev/null))
        smallName="tikz/normal${#tmp[@]}.pdf"
        name="${1}tikz/normal${#tmp[@]}.tex"
        echo $name
        touch $name
        echo "\input{${2}preambule}" >> $name
        echo "" >> $name
        echo "\begin{document}" >> $name
        echo "" >> $name
        for str in ${VAL[@]}; do
          echo $str >> $name
        done
        cat $file | echo 
        echo "" >> $name
        echo "\end{document}" >> $name
        echo ${BEGIN[i]}
        echo ${END[i]}
        echo $file
        sed -i  "${BEGIN[i]},${END[i]}d" $file
        # FIX remove first space and should have good indentation
        sed -i "${BEGIN[i]}i\ \\\includegraphics{${smallName}}" $file
        cat $file | echo
      done 
    fi
  done
   
  DIR_TO_VISIT="$(ls -d ${1}*/ 2>/dev/null)"
  for dir in ${DIR_TO_VISIT}; do
    if [[ $dir != *"/tikz/"* ]]
    then
      echo $dir
      if [ $2 = "./" ]
      then
        find_tikz $dir ../../tikz/
      else
        find_tikz $dir ../$2
      fi
    fi
  done
}

compile_all () {
  DIRS=()
  #readarray -d '' FILES < <(find . -wholename "*/tikz/*.tex")
  readarray -d '' DIRS < <(find . -wholename "*/tikz")
  for dir in $DIRS; do
    echo $dir
    cd $dir
    FILES=()
    readarray -d '' FILES < <(find . -name "*.tex")
    for file in $FILES; do
      echo $file
      if [ $file != "./preambule.tex" ]
      then
        pdflatex -shell-escape $file > /dev/null 
        pdftmp="${file/tex/pdf}"
        pdfcrop $pdftmp $pdftmp > /dev/null
        if $PNG
        then
          convert +profile "*" -density $DPI -units PixelsPerInch ${file/tex/pdf} ${file/tex/png}
        fi
      fi
    done
    rm *.aux *.log *.out
    cd $DIR
  done
}

# Create all document
echo "Extracting..."
#find_tikz ./ ./
mkdir -p tikz
#cp $SOURCE_DIR/preambule.tex tikz/
echo "Compiling ..."
compile_all


