#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

if [ $# -eq 0 ]
then
  echo "Normal single file is used"
  cp ${DIR}/normal/* ./
else
  if [ "$1" = "normal" ]
  then
    cp ${DIR}/normal/* ./
    echo "Normal single file is used"
  elif [ "$1" = "files" ]
  then
    cp ${DIR}/files/* ./
    echo "Multi-files is used"
  else
    echo "$1 unrecognised"
  fi
fi
