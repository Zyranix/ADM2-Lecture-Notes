TEXINPUTS=LatexPackagesBuild//:

### Compilation of the document

# Compiles the full document, assuming gnuplots already exist
full: full.gnuplots
	@TEXINPUTS=${TEXINPUTS} latexmk -pdf -dvi- -latexoption=-interaction=nonstopmode full.tex

# Compiles the master document, assuming gnuplots already exist
master: master.gnuplots
	@TEXINPUTS=${TEXINPUTS} latexmk -pdf -dvi- -latexoption=-interaction=nonstopmode master.tex

# Runs pdflatex on the full document
full-pdflatex: full.gnuplots
	@TEXINPUTS=${TEXINPUTS} pdflatex -interaction=nonstopmode full.tex

# Runs pdflatex on the master document
master-pdflatex: master.gnuplots
	@TEXINPUTS=${TEXINPUTS} pdflatex -interaction=nonstopmode master.tex

# Compiles the full document, as well as re-computing the gnuplots.
full-with-gnuplots: gnuplots-full
	@make full-pdflatex # This ensures re-compilation for the gnuplots
	@make full # Latexmk now takes care of biber etc (possibly no further runs are required)

# Compiles the master document, as well as re-computing the gnuplots.
master-with-gnuplots: gnuplots-master
	@make master-pdflatex
	@make master

#### Clean targets

clean: clean-master clean-full

clean-master:
	@ls | sed -n 's/^\(master\..*\)$$/\1/p' | sed -e '/master.tex/d' | sed -e '/master.gnuplots/d' | xargs --no-run-if-empty rm

clean-full:
	@ls | sed -n 's/^\(full\..*\)$$/\1/p' | sed -e '/full.tex/d' | sed -e '/full.gnuplots/d' | sed -e '/full.cnt/d' | xargs --no-run-if-empty rm

#### Gnuplot-related targets

# Creates the folder for gnuplots of full document
full.gnuplots:
	@mkdir full.gnuplots

# Creates the folder for gnuplots of master document
master.gnuplots:
	@mkdir master.gnuplots

# Runs gnuplot on the gnuplot files of full document
compile-gnuplots-full: full.gnuplots
	@echo "[Make] Running gnuplot in full.gnuplots directory..."
	@for f in full.gnuplots/*.gnuplot ; do [ -f "$$f" ] || continue; gnuplot "$$f"; done

# Runs gnuplot on the gnuplot files of master document
compile-gnuplots-master: master.gnuplots
	@echo "[Make] Running gnuplot in master.gnuplots directory..."
	@for f in master.gnuplots/*.gnuplot ; do [ -f "$$f" ] || continue; gnuplot "$$f"; done

# Runs gnuplot on all gnuplot files
compile-gnuplots: compile-gnuplots-full compile-gnuplots-master

# (Re)computes gnuplot files for full document
gnuplots-full: full.gnuplots
	@rm -r full.gnuplots
	@make full-pdflatex
	@make compile-gnuplots-full

# (Re)computes gnuplot files for master document
gnuplots-master: master.gnuplots
	@rm -r master.gnuplots
	@make master-pdflatex
	@make compile-gnuplots-master

# (Re)computes all gnuplot files
gnuplots: gnuplots-full gnuplots-master

# Gets the current gnuplot directories from origin
get-gnuplots:
	git checkout origin/gnuplots full.gnuplots
	git restore --staged full.gnuplots/
	git checkout origin/gnuplots master.gnuplots
	git restore --staged master.gnuplots/

#### Initialization and configuration of git repository

# Initializes the submodule, i.e. clones it correctly
init-submodule:
	@echo "[Make] Initialising submodules..."
	@git submodule update --init --rebase

# Sets up git hooks for gitinfo2 package
init-git-hooks:
	@echo "[Make] Setting up git hooks for package gitinfo2"
	@cp .travis/git-info-2.sh .git/hooks/post-merge
	@cp .travis/git-info-2.sh .git/hooks/post-checkout
	@cp .travis/git-info-2.sh .git/hooks/post-commit
	@.travis/git-info-2.sh

# Initializes submodule and git hooks for this repository
init: init-submodule init-git-hooks get-gnuplots

# Sets appropriate git configuration for this repository
config:
	@echo "[Make config] Setting git configs to prevent wrong pushes"
	@git config push.recurseSubmodules check
	@git config status.submodulesummary 1
	@echo "[Push annotated tags by default]"
	@git config push.followTags true

# See
# https://stackoverflow.com/a/26339924/16371376
# for explanation
# Lists all targets in this makefile
.PHONY: list
list:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
