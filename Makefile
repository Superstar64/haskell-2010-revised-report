.PHONY: pdf
pdf:
	typst compile haskell-2010-revised.typ

.PHONY: html
html:
	typst compile --format html --features html haskell-2010-revised.typ