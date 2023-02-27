UNIVERSITY= # <empty>, ulm, bern, magdeburg, wernigerode
HANDOUT= # <empty>, y

TEX_FILES := $(wildcard *.tex)
TEX_FILES := $(filter-out 00-overview.tex, $(TEX_FILES))
TEX_FILES := $(filter-out all.tex, $(TEX_FILES))
PDF_FILES = $(TEX_FILES:.tex=.pdf)

MARKER = % < do not remove this comment, it is used by the Makefile >
ifeq ($(HANDOUT),y)
	HANDOUT_PREFIX=
else
	HANDOUT_PREFIX=%
endif

all: $(PDF_FILES) 00-overview.pdf all.pdf

%.pdf: %.tex
	echo $(UNIVERSITY) $(HANDOUT)
	sed -i 's/\(university{\).*\(} $(strip $(MARKER))\)/\1$(strip $(UNIVERSITY))\2/' $<
	sed -i 's/.*\(handout, $(strip $(MARKER))\)/	$(strip $(HANDOUT_PREFIX))\1/' $<
	latexmk --shell-escape -pdf $<
	latexmk -c
	
clean: *.tex
	latexmk -C $?