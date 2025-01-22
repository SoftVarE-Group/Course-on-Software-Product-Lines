#!/usr/bin/env bash
# Cloned and owned from compile_paderborn.sh and simplified for my (Elias) needs.

lecture_names=("introduction" "runtime" "cloneandown" "modeling" "conditional" "modular" "languages" "process" "interactions" "analyses" "testing" "evonance")
university=anonymous

make_overview () {
    cur_lectures=$(printf ",%s" "${lecture_names[@]:0:$lecture_number}")
    cur_lectures=${cur_lectures:1}

    latexmk -quiet -silent -C spl.tex
    rm spl.tex

    spl="\input{spl1.tex}\includeonlylecture{$cur_lectures}\input{spl2.tex}"
    echo $spl > spl.tex

    latexmk="pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error \"\def\ismake{}\def\ishandout{}\def\university{${university}}\input{%S}\""
    latexmk -quiet -silent -pdf -pdflatex="$latexmk" spl.tex
    latexmk -quiet -silent -c spl.tex
    rm spl.*.vrb
    cp -f spl.pdf spl-light.pdf

    latexmk="pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error \"\def\ismake{}\def\ishandout{}\def\isdarkmode{}\def\university{${university}}\input{%S}\""
    latexmk -quiet -silent -pdf -pdflatex="$latexmk" spl.tex
    latexmk -quiet -silent -c spl.tex
    cp -f spl.pdf spl-dark.pdf
    rm spl.*.vrb
    
    mv -f spl-light.pdf spl.pdf
}

is_make_overview=0
while getopts "o" opt
do
    case $opt in
    (o) is_make_overview=1 ;;
    (*) echo "Illegal option $opt" && exit 1 ;;
    esac
done

if [[ -z "$*" ]]; then
    "$0" -o 12
    exit 0
fi


shift $(($OPTIND - 1))
lecture_number=$1

number_re='^[0-9]+$'
if ! [[ ${lecture_number} =~ ${number_re} ]] ; then
    echo "ERROR: ${lecture_number} is not a valid integer";
    exit 1
fi

lecture_index=$((lecture_number-1))
lecture_number_formatted=$(printf "%02d" ${lecture_number})
lecture=$lecture_number_formatted-${lecture_names[$lecture_index]}

TEXFILE=${lecture}.tex
if test -f "${TEXFILE}"; then
    echo $lecture
else
    echo "ERROR: ${TEXFILE} does not exist!"
    exit 1
fi

if [ "$#" -ge 2 ]; then
    university=$2
    echo "Using university ${university}"
fi

cd "$(dirname "$0")" || exit

if test ${is_make_overview} -gt 0 ; then make_overview ; fi