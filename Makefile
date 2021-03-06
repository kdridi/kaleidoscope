PANDOC = pandoc
IFORMAT = markdown
FLAGS = --standalone --toc
TEMPLATE = page.tmpl
STYLE = style.css

CC = gcc
CHAPTERS = chapter2 chapter3 chapter4 chapter5 chapter6 chapter7
OPTS = -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d

all: tutorial.html $(CHAPTERS)

preprocessor:
	ghc $(OPTS) --make preprocessor.hs -o preprocessor

chapter2:
	ghc $(OPTS) --make src/chapter2/*.hs -o chapter2

chapter3:
	ghc $(OPTS) --make src/chapter3/*.hs -o chapter3

chapter4:
	$(CC) -fPIC -shared src/chapter4/cbits.c -o src/chapter4/cbits.so
	ghc $(OPTS) src/chapter4/cbits.so --make src/chapter4/*.hs -o chapter4

chapter5:
	$(CC) -fPIC -shared src/chapter5/cbits.c -o src/chapter5/cbits.so
	ghc $(OPTS) src/chapter5/cbits.so --make src/chapter5/*.hs -o chapter5

chapter6:
	$(CC) -fPIC -shared src/chapter6/cbits.c -o src/chapter6/cbits.so
	ghc $(OPTS) src/chapter6/cbits.so --make src/chapter6/*.hs -o chapter6

chapter7:
	$(CC) -fPIC -shared src/chapter7/cbits.c -o src/chapter7/cbits.so
	ghc $(OPTS) src/chapter7/cbits.so --make src/chapter7/*.hs -o chapter7

%.html: %.md
	./preprocessor < $< | $(PANDOC) -c $(STYLE) --template $(TEMPLATE) -s -f $(IFORMAT) -t html $(FLAGS) -o $@

%.pdf: %.md
	./preprocessor < $< | $(PANDOC) -f $(IFORMAT) --toc -o $@

clean:
	-rm $(CHAPTERS)
