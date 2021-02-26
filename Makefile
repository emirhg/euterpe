#!/bin/bash
# Script para generar un PDF utilizando pdflatex y una plantilla descargada de internet
# Author: Emir Herrera González
# Licencia GNU GPLv2

define make_pdf
	TEXINPUTS=./tesis:./tesis/lib/vrmpx/templateTesisITAM/:./tesis/lib/vrmpx/templateTesisITAM/Figures: pdflatex --output-directory=./output tesis/main.tex
endef

define make_bbl
	BIBINPUTS=./tesis bibtex output/main
endef

define loop_build_ref
latex_count=3
while egrep -s 'Rerun (LaTeX|to get cross-references right)' output/main.log && [ $$latex_count -gt 0 ]; \
		do \
			echo "Rerunning latex...."; \
			$(call make_pdf); \
			latex_count=`expr $$latex_count - 1`; \
		done
endef

all: doc

doc:
	$(call make_pdf)
	$(call make_bbl)
	@$(call loop_build_ref)
