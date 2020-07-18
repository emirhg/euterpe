#!/bin/bash
# Script para generar un PDF utilizando pdflatex y una plantilla descargada de internet
# Author: Emir Herrera González
# Licencia GNU GPLv2

export TEXINPUTS=.:./lib/vrmpx/templateTesisITAM/:./lib/vrmpx/templateTesisITAM/Figures:

pdflatex main.tex
