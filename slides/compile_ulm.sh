#! /bin/bash

lecture_names=("introduction" "runtime" "cloneandown" "modeling" "conditional" "modular" "languages" "process" "interactions" "analyses" "testing" "evonance" "advanced" "conclusion")
university=ulm

make_lecture () {
    latexmk -quiet -silent -C ${TEXFILE}
    make ${lecture}.pdf university=${university} handout=n darkmode=n
    rm ${lecture}.*.vrb
    mv ${lecture}.pdf ${lecture}_animated.pdf

    make ${lecture}.pdf university=${university} handout=y darkmode=n
    rm ${lecture}.*.vrb
    mv ${lecture}.pdf ${lecture}_handout.pdf

    make ${lecture}.pdf university=${university} handout=y darkmode=y
    rm ${lecture}.*.vrb
    mv ${lecture}.pdf ${lecture}_handout_dark.pdf
}

make_overview () {
    cur_lectures="${lecture_names[@]:0:$lecture_number}"
    cur_lectures=$(printf ",%s" "${cur_lectures[@]}")
    cur_lectures=${cur_lectures:1}

    latexmk -quiet -silent -C spl.tex
    rm spl.tex

    spl="\input{spl1.tex}\includeonlylecture{$cur_lectures}\input{spl2.tex}"
    echo $spl > spl.tex

    latexmk="pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error \"\def\ismake{}\def\ishandout{}\def\university{${university}}\input{%S}\""
    latexmk -quiet -silent -pdf -pdflatex="$latexmk" spl.tex
    latexmk -quiet -silent -c spl.tex
    rm spl.*.vrb
    mv spl.pdf spl_handout.pdf

    latexmk="pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error \"\def\ismake{}\def\ishandout{}\def\isdarkmode{}\def\university{${university}}\input{%S}\""
    latexmk -quiet -silent -pdf -pdflatex="$latexmk" spl.tex
    latexmk -quiet -silent -c spl.tex
    mv spl.pdf spl_handout_dark.pdf
    rm spl.*.vrb
    rm spl.tex
}

make_recording () {
    latexmk -quiet -silent -C ${TEXFILE}
    make ${lecture}.pdf university=recording handout=n darkmode=y
    rm ${lecture}.*.vrb
    mv ${lecture}.pdf ${lecture}_recording.pdf

    make ${lecture}.pdf university=recording handout=y darkmode=n
    rm ${lecture}.*.vrb
    mv ${lecture}.pdf ${lecture}_recording_handout.pdf

    make ${lecture}.pdf university=recording handout=y darkmode=y
    rm ${lecture}.*.vrb
    mv ${lecture}.pdf ${lecture}_recording_handout_dark.pdf
}

while getopts "lro" opt
do
    case $opt in
    (l) is_make_lecture=1;echo "l" ;;
    (r) is_make_recording=1;echo "r" ;;
    (o) is_make_overview=1;echo "o" ;;
    (*) echo "Illegal option $opt" && exit 1 ;;
    esac
done

shift $(($OPTIND - 1))
lecture_number=$1

# Return if first argument is not a positive integer
number_re='^[0-9]+$'
if ! [[ ${lecture_number} =~ ${number_re} ]] ; then
    echo "ERROR: ${lecture_number} is not a valid integer";
    exit 1
fi

lecture_index=$((lecture_number-1))
lecture_number=$(printf "%02d" ${lecture_number})
lecture=$lecture_number-${lecture_names[$lecture_index]}

# Return if tex file does not exist
TEXFILE=${lecture}.tex
if test -f "${TEXFILE}"; then
    echo $lecture
else
    echo "ERROR: ${TEXFILE} does not exist!"
    exit 1
fi

if test $is_make_lecture -gt 0; then make_lecture ; fi
if test $is_make_recording -gt 0; then make_recording ; fi
if test $is_make_overview -gt 0; then make_overview ; fi
