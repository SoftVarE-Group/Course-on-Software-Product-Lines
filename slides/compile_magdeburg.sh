#!/usr/bin/env bash
# Cloned and owned from compile_paderborn.sh and simplified for my (Elias) needs.

lecture_names=("introduction" "runtime" "cloneandown" "modeling" "conditional" "modular" "languages" "process" "interactions" "analyses" "testing" "evonance")
university=magdeburg
semester=2025w

archive_path="$(dirname "$0")/../../teaching-spl-archive/"

upper_first () {
    printf "%s" "${1%"${1#?}"}" | tr '[:lower:]' '[:upper:]' && printf "%s" "${1#?}"
}

make_lecture () {
	outpath="${archive_path}${semester}-$(upper_first "$university")/"
    mkdir -p "${outpath}animated"
    
    latexmk -quiet -silent -C ${TEXFILE}
    make ${lecture}.pdf university=${university} handout=n darkmode=n
    rm ${lecture}.*.vrb
    mv -f ${lecture}.pdf ${outpath}animated/${lecture}.pdf

    make ${lecture}.pdf university=${university} handout=y darkmode=n
    rm ${lecture}.*.vrb
    mv -f ${lecture}.pdf ${outpath}${lecture}.pdf
}

make_overview () {
	outpath="${archive_path}${semester}-$(upper_first "$university")/"

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
    mv -f spl.pdf ${outpath}spl.pdf

    latexmk="pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error \"\def\ismake{}\def\ishandout{}\def\isdarkmode{}\def\university{${university}}\input{%S}\""
    latexmk -quiet -silent -pdf -pdflatex="$latexmk" spl.tex
    latexmk -quiet -silent -c spl.tex
    cp -f spl.pdf ${outpath}spl-dark.pdf
    rm spl.*.vrb
}

is_make_lecture=0
is_make_overview=0
while getopts "lo" opt
do
    case $opt in
    (l) is_make_lecture=1 ;;
    (o) is_make_overview=1 ;;
    (*) echo "Illegal option $opt" && exit 1 ;;
    esac
done

if [[ -z "$*" ]]; then
    for i in "${!lecture_names[@]}"; do
        "$0" -l "$(($i+1))"
    done
    "$0" -o "$(($i+1))"
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

if test ${is_make_lecture} -gt 0 ; then make_lecture ; fi
if test ${is_make_overview} -gt 0 ; then make_overview ; fi