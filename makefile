HOME_DIR=$(shell pwd)
STYLE_DIR=$(HOME_DIR)/xsl
SED_DIR=$(HOME_DIR)/sed
TEX_DIR=$(HOME_DIR)/tex

INTER_XML=$(INPUT_DIR)/final.xml

OUTPUT_NAME=output
OUTPUT_FILENAME=$(HOME_DIR)/$(OUTPUT_NAME)
OUTPUT_PDF=$(OUTPUT_FILENAME).pdf
OUTPUT_TEX=$(OUTPUT_FILENAME).tex
OUTPUT_IDX=$(OUTPUT_NAME).idx


INPUT_SPACE=$(shell zipinfo -1 $(SPACE) *index.html)
INPUT_DIR=$(HOME_DIR)/$(dir $(INPUT_SPACE))

export CLASSPATH=/usr/share/java/saxonb.jar


all: view_pdf
	@echo $(SPACE)
	@echo $(INPUT_SPACE)
	@echo $(INPUT_DIR)
	@echo Build all done!


# Prepare weird Confluence XHTML to be consumed by normal parser
validate_space:
	if [ -z "$(SPACE)" ] ; then \
		echo "No space passed!" ; \
		return 1 ;\
	fi
	if [ -z "$(INPUT_SPACE)" ] ; then \
		echo "Input zip empty; double check zipfile!" ; \
		return 1 ;\
	fi \

# Clean up old crap and 
open_archive: validate_space
	rm -rf $(INPUT_DIR)
	unzip $(SPACE)

# Prepare weird Confluence XHTML to be consumed by normal parser
prepare_html: open_archive
	@echo $(INPUT_DIR)
	cd $(INPUT_DIR) ; \
	for f in *.html ; \
	do \
		echo $(INPUT_DIR)/$$f ; \
		../page.py $(INPUT_DIR)/$$f ; \
		sed -f $(SED_DIR)/input.sed -i $(INPUT_DIR)/$$f ; \
	done
	cp -ur $(INPUT_DIR)/attachments $(HOME_DIR)

# Build single master page using space index page.
assemble_document: prepare_html
	java net.sf.saxon.Transform -xsl:$(STYLE_DIR)/index.xsl -s:$(INPUT_DIR)/index.html > $(INTER_XML)

# Convert master page to LaTeX, and combine with formatting rules
build_latex: assemble_document
	cp -f $(TEX_DIR)/header.tex $(OUTPUT_TEX)
	cat $(INTER_XML) \
		| tidy -xml -indent -utf8 > $(INTER_XML)2
	java net.sf.saxon.Transform -xsl:$(STYLE_DIR)/latex.xsl -s:$(INTER_XML)2 > tmp.1
	sed -f $(SED_DIR)/output.sed tmp.1 >> $(OUTPUT_TEX)
	rm tmp.1
	cat $(TEX_DIR)/footer.tex >> $(OUTPUT_TEX)

# No longer supported
build_xslfo:
	fop -xml $(INTER_XML) -xsl $(STYLE_DIR)/document.xsl -foout $(INPUT_DIR)/$(OUTPUT_NAME).fo

# Run, rerun (build cross-references), display
# If it works the first time, it will work the second time.
build_pdf: build_latex
	pdflatex -halt-on-error $(OUTPUT_TEX)
	cd $(HOME_DIR) ; makeindex $(OUTPUT_IDX)
	pdflatex -halt-on-error $(OUTPUT_TEX)

view_pdf: build_pdf
	evince $(OUTPUT_PDF)


clean:
	rm -f $(OUTPUT_FILENAME).aux
	rm -f $(OUTPUT_FILENAME).tex
	rm -f $(OUTPUT_FILENAME).idx
	rm -f $(OUTPUT_FILENAME).log
	rm -f $(OUTPUT_FILENAME).out
	rm -f $(OUTPUT_FILENAME).toc
	rm -f $(OUTPUT_FILENAME).pdf
