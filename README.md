[![Build Status](https://api.travis-ci.com/kesslermaximilian/GeometrieUndTopologie.svg)](https://travis-ci.com/kesslermaximilian/GeometrieUndTopologie)

# Discrete Optimization

These are my lecture notes for the module 'Algorithmic Discrete Optimization', taught by [Prof. Dr. Tom McCormick](https://www.sauder.ubc.ca/people/thomas-mccormick) in the summer term 2022 at the TU Berlin. There is no guarantee for completeness or correctness.

- The homepage of the course can also be found [here](https://www3.math.tu-berlin.de/coga/study/teaching/adm-ii-summer-2022/)
- The [most recent version](https://kesslermaximilian.github.io/GeometrieUndTopologie/2021_Topologie.pdf) of this script is made available with [Travis CI](https://github.com/traviscibot). You can also have a look at the [generated log files](https://kesslermaximilian.github.io/GeometrieUndTopologie/2021_Topologie.log)

## Set-up
This set-up is largely inspired by Maximilian Keßler's set-up for lecture notes. Please refer to [this link](https://gitlab.com/latexci/packages/LatexPackages) for further instructions. This document uses custom packages, so you won't be directly able to compile this document!

## File Structure
This section explains the TeX-structure of the document

```
.
├── figures                         # contains all figures used by TeX
│   ├── some_figure_1.pdf          
│   ├── some_figure_1.pdf_tex
│   ├── some_figure_1.svg
├── inputs                          # all TeX files input from the main document
│   ├── exercises                   # sources for the exercise sheets in the appendix
│   │   ├── Blatt1.tex
│   │   ├── Blatt2.tex
│   │   ├── exercises.tex
│   │   └── preambleBlatt.tex       # preamble for the exercise sheets in appendix
│   ├── lectures                    # sources of each of the lectures
│   │   ├── lec_01.tex              
│   │   ├── lec_02.tex
│   │   └── ...
│   ├── abstract.tex                # abstract at beginning of document
│   └── environments.tex            # explanation of environments in appendix
├── LatexPackages                   # Submodule that contains the custom packages used
│   ├── mkessler-bibliography.sty
│   └── ...
├── references                      # BibLatex sources
│   ├── bibliography.bib
│   └── images.bib
├── full.tex                        # The main file TeX is run on.
└── master.tex                      # The TeX-file used for quick compilations during lecture. Some parts are missing if this is used as main.
```
