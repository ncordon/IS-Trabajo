#!/bin/bash

TEX_DIR=../tex

source-highlight -f latex -s sh -i geninfo.sh -o $TEX_DIR/geninfo.tex
source-highlight -f latex -s python -i iostat_plotter_v3.py -o $TEX_DIR/iostat_plotter_v3.tex

