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

# There is a sodding bug in LibreOffice batch processing. I would do the
# following line manually because I have been unable to get this working
# automatically (it misses out the captions).

img/flow.png: img/flow.odg
	soffice \
		--headless \
		--convert-to png \
	    --outdir img \
	    img/flow.odg

pdf: paper.md img/flow.png
	pandoc \
		--from markdown $(WINDOWS) \
		--to latex \
		--filter pandoc-crossref \
		--bibliography=library.bib \
		--columns=50 \
		--output paper.pdf \
		--variable classoption="twocolumn" \
		"./paper.md"

html: paper.md img/flow.png
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

word: paper.md img.png
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
	-rm -rf \
		img/flow.png \
		paper.pdf \
		paper.html
		tex2pdf.* \
		*bib.bak 2>/dev/null

help:
	@echo pdf - makes the pdf
	@echo html - makes the html
	@echo word - makes a disgusting word document
	@echo clean - tidies everything up.



