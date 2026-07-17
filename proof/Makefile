project=semirings

all:$(project).pdf

diagram_list := $(shell cat diagram_list)

LATEXMK := $(shell command -v latexmk 2> /dev/null)

.PHONY: all clean $(project) $(project).pdf

$(project): $(project).pdf

$(project).pdf: diagram
ifndef LATEXMK
	pdflatex $(project).tex
	pdflatex $(project).tex
	bibtex $(project)
	pdflatex $(project).tex
else
	"latexmk" -xelatex -synctex=1 $(project).tex
endif

diagram: $(diagram_list)

diagram-%.mps: diagram-%.mp
	@echo Generating diagrams $*...
	mpost --tex=latex diagram-$*.mp

clean:
	rm -rf *.out *.dvi *.log *.out *.aux $(project).pdf *.bbl *.blg *.fdb_latexmk *.glo *.glsdefs *.ist *.synctex *.thm *.toc *.tdo *.fls
