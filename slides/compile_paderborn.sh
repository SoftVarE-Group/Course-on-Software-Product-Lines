#! /bin/bash
# Usage
#   ./compile_paderborn.sh -options <nr>
# where options is a string consisting of the characters l, o, f, r
#   l = lecture
#   o = overview
#   f = full
#   r = recording
# and <nr> is the number of the lecture you want to compile.
# The output will be written to the value stored in "slide_path" below.
# Example, to compile the lecture 3 and also prepare the overview slides (i.e., a big pdf containing lectures 1-3), you can run
#   ./compile_paderborn.sh -lo 3
# Important: Run this script from the directory the script is in. Otherwise paths for output pdfs might be wrong.

lecture_names=("introduction" "runtime" "cloneandown" "modeling" "conditional" "modular" "languages" "process" "interactions" "analyses" "testing" "evonance")
university=paderborn
semester=2024s

archive_path="../../SPL-Slide-Archive/"
slide_path="../../SPL-Slides/${semester}t/"

make_lecture () {
	outpath="${archive_path}${semester}-${university^}/"
    latexmk -quiet -silent -C ${TEXFILE}
    make ${lecture}.pdf university=${university} handout=n darkmode=n
    rm ${lecture}.*.vrb
    mv -f ${lecture}.pdf ${outpath}animated/${lecture}.pdf

    make ${lecture}.pdf university=${university} handout=y darkmode=n
    rm ${lecture}.*.vrb
    mv -f ${lecture}.pdf ${outpath}${lecture}.pdf

    make ${lecture}.pdf university=${university} handout=y darkmode=y
    rm ${lecture}.*.vrb
    cp -f ${lecture}.pdf ${outpath}${lecture}-dark.pdf
}

make_overview () {
	outpath="${archive_path}${semester}-${university^}/"

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

make_full_overview () {
    cur_lectures=$(printf ",%s" "${lecture_names[@]}")
    cur_lectures=${cur_lectures:1}

    latexmk -quiet -silent -C spl.tex
    rm spl.tex

    spl="\input{spl1.tex}\includeonlylecture{$cur_lectures}\input{spl2.tex}"
    echo $spl > spl.tex

    latexmk="pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error \"\def\ismake{}\def\ishandout{}\def\university{recording}\input{%S}\""
    latexmk -quiet -silent -pdf -pdflatex="$latexmk" spl.tex
    latexmk -quiet -silent -c spl.tex
    rm spl.*.vrb
    mv -f spl.pdf ${slide_path}spl.pdf

    latexmk="pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error \"\def\ismake{}\def\ishandout{}\def\isdarkmode{}\def\university{recording}\input{%S}\""
    latexmk -quiet -silent -pdf -pdflatex="$latexmk" spl.tex
    latexmk -quiet -silent -c spl.tex
    cp -f spl.pdf ${slide_path}spl-dark.pdf
    rm spl.*.vrb
}

make_recording () {
	outpath="${archive_path}${semester}-Recording/"
    latexmk -quiet -silent -C ${TEXFILE}
    make ${lecture}.pdf university=recording handout=n darkmode=y
    rm ${lecture}.*.vrb
    mv -f ${lecture}.pdf ${outpath}${lecture}.pdf

    make ${lecture}.pdf university=recording handout=y darkmode=n
    rm ${lecture}.*.vrb
    mv -f ${lecture}.pdf ${slide_path}${lecture}.pdf

    make ${lecture}.pdf university=recording handout=y darkmode=y
    rm ${lecture}.*.vrb
    cp -f ${lecture}.pdf ${slide_path}${lecture}-dark.pdf
}

is_make_lecture=0
is_make_recording=0
is_make_overview=0
is_make_full_overview=0
while getopts "lrof" opt
do
    case $opt in
    (l) is_make_lecture=1 ;;
    (r) is_make_recording=1 ;;
    (o) is_make_overview=1 ;;
    (f) is_make_full_overview=1 ;;
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
lecture_number_formated=$(printf "%02d" ${lecture_number})
lecture=$lecture_number_formated-${lecture_names[$lecture_index]}

# Return if tex file does not exist
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

# create slides for recording first, such that university-specific files remain in the slides folder
if test ${is_make_recording} -gt 0 ; then make_recording ; fi
if test ${is_make_full_overview} -gt 0 ; then make_full_overview ; fi
if test ${is_make_lecture} -gt 0 ; then make_lecture ; fi
if test ${is_make_overview} -gt 0 ; then make_overview ; fi

