#! /bin/bash

# First argument must be the number of the lecture
lecture_number=$1
lecture_names=("introduction" "runtime" "cloneandown" "modeling" "conditional" "modular" "languages" "process" "interactions" "analyses" "testing" "evonance" "advanced" "conclusion")

university=ulm

lecture_index=$((lecture_number-1))
lecture=$lecture_number-${lecture_names[$lecture_index]}

cur_lectures="${lecture_names[@]:0:$lecture_number}"
cur_lectures=$(printf ",%s" "${cur_lectures[@]}")
cur_lectures=${cur_lectures:1}

echo $cur_lectures
echo $lecture

latexmk -quiet -silent -C
rm spl.tex

spl="\input{spl1.tex}\includeonlylecture{$cur_lectures}\input{spl2.tex}"
echo $spl > spl.tex

make $lecture.pdf university=${university} handout=n darkmode=n
mv ${lecture}.pdf ${lecture}_animated.pdf

make ${lecture}.pdf university=${university} handout=y darkmode=n
mv ${lecture}.pdf ${lecture}_handout.pdf

make ${lecture}.pdf university=${university} handout=y darkmode=y
mv ${lecture}.pdf ${lecture}_handout_dark.pdf

latexmk="pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error \"\def\ismake{}\def\ishandout{}\def\university{${university}}\input{%S}\""
latexmk -quiet -silent -pdf -pdflatex="$latexmk" spl.tex
mv spl.pdf spl_handout.pdf

latexmk="pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error \"\def\ismake{}\def\ishandout{}\def\isdarkmode{}\def\university{${university}}\input{%S}\""
latexmk -quiet -silent -pdf -pdflatex="$latexmk" spl.tex
mv spl.pdf spl_handout_dark.pdf

make ${lecture}.pdf university=recording handout=n darkmode=y
mv ${lecture}.pdf ${lecture}_recording.pdf

make ${lecture}.pdf university=recording handout=y darkmode=n
mv ${lecture}.pdf ${lecture}_recording_handout.pdf

make ${lecture}.pdf university=recording handout=y darkmode=y
mv ${lecture}.pdf ${lecture}_recording_handout_dark.pdf

#latexmk -quiet -silent -C
#rm spl.tex
