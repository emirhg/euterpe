#!/bin/bash
# Script para generar un PDF utilizando pdflatex y una plantilla descargada de internet
# Author: Emir Herrera González
# Licencia GNU GPLv2

export TEXINPUTS=./tesis:./tesis/lib/vrmpx/templateTesisITAM/:./tesis/lib/vrmpx/templateTesisITAM/Figures:

all: doc

doc:
	pdflatex --output-directory=./output tesis/main.tex

