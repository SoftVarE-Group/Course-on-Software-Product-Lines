handout?=y# n, y
darkmode?=n# n, y
university?=# <empty>, ulm, bern, magdeburg, wernigerode

TEX_FILES := $(wildcard *.tex)
PDF_FILES = $(TEX_FILES:.tex=.pdf)

ifeq ($(handout),y)
	def_handout=\def\ishandout{}
else
	def_handout=
endif

ifeq ($(darkmode),y)
	def_darkmode=\def\isdarkmode{}
else
	def_darkmode=
endif

all: $(PDF_FILES)

%.pdf: %.tex
	latexmk -quiet -silent -pdf -pdflatex='pdflatex %O -interaction=batchmode -synctex=1 -halt-on-error "\def\ismake{}$(def_handout)$(def_darkmode)\def\university{$(university)}\input{%S}"' $<
	latexmk -quiet -silent -c $<
	
clean: *.tex
	latexmk -C $?
