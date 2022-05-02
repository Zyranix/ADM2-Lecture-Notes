[![Build Status](https://api.travis-ci.com/kesslermaximilian/GeometrieUndTopologie.svg)](https://travis-ci.com/kesslermaximilian/GeometrieUndTopologie)

# Geometrie und Topologie

These are my lecture notes for the 'Einführung in die Geometrie und Topologie', taught by [Daniel Kasprowski](http://www.math.uni-bonn.de/people/daniel/) in the summer term 2021 at the University of Bonn. There is no guarantee for completeness or correctness.

- The homepage of the course can also be found [here](http://www.math.uni-bonn.de/people/daniel/2021/geotopo/)
- The [most recent version](https://kesslermaximilian.github.io/GeometrieUndTopologie/2021_Topologie.pdf) of this script is made available with [Travis CI](https://github.com/traviscibot). You can also have a look at the [generated log files](https://kesslermaximilian.github.io/GeometrieUndTopologie/2021_Topologie.log)

## Set-up
This document uses custom packages, so you you won't be directly able to compile this document. They are available as my [Latex Packages](https://github.com/kesslermaximilian/LatexPackages) repository and added as a submodule to this repository. You will have to clone them as well and tell TeX where to find these before compiling. Follow these steps:

### For the quick:
- Clone the repository with   
```git clone https://github.com/kesslermaximilian/GeometrieUndTopologie.git```   
- Enter it with `cd GeometrieUndTopologie`
- Run `make init`. This gets the submodule, sets up githooks and gets the generated gnuplot files, don't worry about it too much
- Run `make config`. This sets some local git configuration for the repository which I recommend.
- To build the document, run `make full` or even just `make`. This will build the document now
- You can now edit the source files, `full.tex` and the included files found in `inputs/`. To compile, just run `make` again.

Further explanation on what all of this does can be found in the following sections

### Setting up repository
After having cloned the repository, we still have to:
 
- Get the submodule `LatexPackages`. This is what `make init-submodule` does via the `git submodule update --init --rebase` command.
- Set up some git hooks for the `gitinfo2` package. These tell `git` to write some metadata that `TeX` can read in later. `make init-git-hooks` sets this up correctly and runs these a first time.
- If you don't plan to run `gnuplot` yourself, obtain the gnuplot tables. This is done via `make get-gnuplots`.

`make init` combines the above three commands so that your repository is ready to use

### Configuring git
I recommand to configure
- `git config push.recurseSubmodules check`. This prevents you from pushing changes in this repository without also pushing changes in the submodule, as this would leave others unable to obtain your repository state
- `git config status.submodulesummary 1`. This adds a summary of the submodule to the `git status` command.
- `git config push.followTags true`. This pushes annotated `git tag`s that are reachable to origin automatically.

`make config` sets these configs for you.

#### SSH issues
If you are usually accessing git using `ssh`, it is possible that you have trouble cloning the submodule, as this is added over `https`. You will have to clone the usual repository first and then edit the `.submodules` file `git` provides and change the url of the submodule to the `ssh` version manually. Then run `gut submodule update` with above arguments. This should clone the submodule via `ssh` now.

### Tell TeX  where to find the packages
Now that we obtained all neccessary resources and configured git correctly, we are ready to compile the document. For this, we have to tell TeX where to find the packages we obtained as a submodule.   
By default, TeX will try to search for packages in your source folder, your tex installation folder (e.g. TeXLive) or your custom TeX folder (typically `~/texmf/tex/latex`).
- We use the `TEXINPUTS` environment variable to achieve this, so before manual compiling just enter   
```export TEXINPUTS=LatexPackages//:```   
in your shell.
- TeX will now look in this directory (relative to the source file) for packages and properly find the custom packages. Note that this only holds for the current shell, you will have to enter this for each new shell you start.
- To simplify, there is a shell script `export_texinputs.sh` that will execute exactly this. To call it, use `source ./export_texinputs.sh` so that the export command is executed in your current shell and not in a newly-created subshell. This is e.g. useful if you start an editor from your shell that needs to find the packages.

For further simplification, the `Makefile` handles this exporting for you and provides several compilation commands:

- `make full-pdflatex`. This just runs a plain `pdflatex` on the full document - with correctly set `TEXINPUTS` variable
- `make full`. This runs `latexmk` on your main document, which takes care of `biber` for the bibliography and compiles a sufficient number of times for all references to work

For further make directives regarding `gnuplots`, see the corresponding section.

## Document structure

### File Structure
This section explains the TeX-structure of the document

```
.
├── figures                         # contains all figures used by TeX
│   ├── some_figure_1.pdf          
│   ├── some_figure_1.pdf_tex
│   ├── some_figure_1.svg
├── full.gnuplots                   # directory for the gnuplots
│   ├── some_plot.gnuplot
│   └── some_plot.table
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
└── full.tex                        # The main file TeX is run on
```

### Why two files?
You may have noticed that there is also the `master.tex` file. This is very similar to the `full.tex` and includes the same resources. I use this as a lightweight version for write-up, and don't include all lectures / the appendix etc to increase compilation speed.   
All commands that the `Makefile` provides have a `master` version (just replace `full` with `master`) as well that are then run on this document.

### Figures
I use a combination of 

- hand-drawn figures, if i did not have time to make a proper one yet (or no motivation)
- inkscape figures in ```.pdf_tex``` format, the source files are in the ```figures``` directory
- external figures copied from elsewhere, also found in ```figures```. You can find the source in the document in this case
- TikZ figures

and last but not least
#### Gnuplots
TikZ provides generating plots with the external tool `gnuplots`. For this

- TikZ generates a `.gnuplot` file in `full.gnuplots` holding the data that gnuplot needs to generate
- `gnuplot` has to be run on this file, generating a `.table` file from this
- On another run of TeX, TikZ can now read in the `.table` file with the coordinates it needs to generate a plot in the PDF document.

Thus even without having `gnuplot` installed, you can compile this document correctly if you have access to the `.table` files.

- For this, Travis CI generates the tables automatically and pushes them to GitHub.
- You can now obtain them via `make get-gnuplots`. This is also what is included in `git init`, but just in case you lost the tables, run this single make command separately.

If you want to run `gnuplot` yourself, you will first have to install it (on Debian via `sudo apt-get install gnuplot`), and then run one of the following make commands:

- `make compile-gnuplots<-full|-master>` This will just run `gnuplot` on the TikZ-generated files in the corresponding directories. Note however, that this does not invoke TeX
- `make gnuplots<-full|-master>` This will delete gnuplot tables, run `pdflatex` once and then run gnuplot on the generated files so that they are up to date. Note that this does *not* mean that the plots are already drawn correctly in the PDF file
- `make <full|master>-with-gnuplots`. This runs a complete build for the corresponding document, regenerating the gnuplot files and compiling the document correctly with `latexmk`. So if you  want to make sure you get the correctly built pdf file, and have gnuplot installed, run this build.

## Options
TODO. maybe just reference to the Package repository?

There are several (custom) compiling options:
- ```lecturenumbers``` (default): Numbers the environments like in the lecture
- ```truenumbers```: (overwrites lecturenumbers) Numbers like one would 'usually' do it, i.e. every Theorem etc. is numbered
- ```numberall```: (overwrites lecturenumbers) Number remarks etc. as well
- ```nostars```: Don't show stars at custom environments (makes them fit more into the document), by default this is turned off (so stars are shown)
- ```nodaggers```: Don't show the daggers at edited environments, also turned off by default
- ```excludestars```: Don't show the self-added environments. If you don't like my comments, use this option when compiling
- ```excludeoral```: Exclude the oral remarks from the document (by default, thye are shown).

To use these, just add them (separated by comma) in the first line of ```Topologie.tex``` into the options of the document class.

test
