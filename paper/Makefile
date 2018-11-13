INSTITUTE_1=The James Hutton Institute, Craigiebuckler, \
Aberdeen, AB15 8QH, \
Scotland UK \
\url{http://www.hutton.ac.uk} \\\\ \
\email{\{doug.salt,gary.polhill\}@hutton.ac.uk}

WINDOWS = 
OSTYPE=$(shell uname)
ifneq (,$(findstring CYGWIN, $(OSTYPE))) 
	WINDOWS=--latex-engine="D:\\cygwin\\usr\\local\\bin\\pdflatex.exe" 
endif

all: pdf

#img/ontology-of-variables.png: img/ontology-of-variables.dot
#	dot \
#		-T png \
#		-o img/ontology-of-variables.png \
#		img/ontology-of-variables.dot
#

# This doesn't work very well if you do it automatically - I have not managed
# to work out what parameter is screwing up. If you do it this way, then you
# loose the text.

#img/example.png: img/example.odg
#	soffice \
#		--headless \
#		--convert-to png \
#	    --outdir img \
#	    img/example.odg

pdf: paper.md
	@echo pandoc \
		--from markdown $(WINDOWS) \
		--to latex \
		--filter pandoc-crossref \
		--bibliography=library.bib \
		--output paper.pdf \
		--columns=50 \
	    --variable classoption="twocolumn" \
		"./paper.md"
	pandoc \
		--from markdown $(WINDOWS) \
		--to latex \
		--filter pandoc-crossref \
		--bibliography=library.bib \
		--columns=50 \
		--output paper.pdf \
	    --variable classoption="twocolumn" \
		"./paper.md"

html: paper.md 
	pandoc \
		--standalone \
		--from markdown  $(WINDOWS)\
		--to html \
		--variable title="$(TITLE)" \
		--variable author="$(AUTHOR_1) \and $(AUTHOR_2)" \
		--variable institute="\"${INSTITUTE_1}\"" \
		--filter pandoc-crossref \
		--bibliography=library.bib \
		--output "paper.html" \
		"./paper.md"

word: paper.md 
	pandoc \
		--standalone \
		--from markdown  $(WINDOWS)\
		--to docx \
		--variable title="$(TITLE)" \
		--variable author="$(AUTHOR_1) \and $(AUTHOR_2)" \
		--variable institute="\"${INSTITUTE_1}\"" \
		--filter pandoc-crossref \
		--bibliography=library.bib \
		--output "paper.docx" \
		"./paper.md"
clean:
	rm -rf paper.pdf \
		paper.html
		tex2pdf.* \
		*bib.bak

help:
	@echo pdf - makes the pdf
	@echo html - makes the html
	@echo word - makes a disgusting word document
	@echo clean - tidies everything up.



