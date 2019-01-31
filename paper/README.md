A directory containing the bits required to make a paper describing the NetLogo
gpg plugin.

This directory contains the following files.

+ Makefile - the make file to make the paper. `make help` to get the options
  avialable.
+ README.md - this file
+ img - a directory containing raw and processed image files.
+ library.bib - the bibtex file containing the references fo the paper
+ paper.md - the actual paper itself in markdown
+ paper.pdf - a pdf version of the paper

The paper devlopment cycle is an iteration of

1. <edit> paper.md
2 make pdf
3 <view the> paper.pdf (or use zathura which automatically updates on change)

To use this successfully then you need `pandoc`, with the pandoc-crossref
plugin, `make`, Libreoffice for for the images, and some kind of text editor.
The markdown is exactly as that used in Rmarkdown..
