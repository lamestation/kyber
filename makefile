
HOME_DIR=$(shell pwd)
OUTPUT_DIR=$(HOME_DIR)/output
STYLE_DIR=$(HOME_DIR)/stylesheets
CONFIG_DIR=$(HOME_DIR)

OUTPUT_NAME=output
OUTPUT_DOC=$(OUTPUT_DIR)/final.xml

INPUT_SPACE=$(shell zipinfo -1 $(SPACE) *index.html)
INPUT_DIR=$(HOME_DIR)/$(dir $(INPUT_SPACE))

all: validate_space
all: open_archive
all: prepare_html
all: assemble_document
all: build_latex
#all: build_pdf
	@echo $(SPACE)
	@echo $(INPUT_SPACE)
	@echo $(INPUT_DIR)
	@echo Build all done!

validate_space:
	if [ -z "$(SPACE)" ] ; then \
		echo "No space passed!" ; \
		return 1 ;\
	fi \

open_archive:
	rm -rf $(INPUT_DIR)
	rm -rf $(OUTPUT_DIR)
	unzip $(SPACE)
	mkdir -p $(OUTPUT_DIR)

# Prepare weird Confluence XHTML to be consumed by normal parser
prepare_html:
	@echo $(INPUT_DIR)
	cd $(INPUT_DIR) ; \
	for f in *.html ; \
	do \
		echo $(INPUT_DIR)/$$f ; \
		../page.py $(INPUT_DIR)/$$f ; \
		sed -i -e '/<META/d' $(INPUT_DIR)/$$f ; \
		sed -i -e 's/&nbsp;//g' $(INPUT_DIR)/$$f ; \
		tidy -asxml -o $(OUTPUT_DIR)/$$f -numeric --force-output yes $(INPUT_DIR)/$$f 2>/dev/null; \
		cp -f $(INPUT_DIR)/$$f $(OUTPUT_DIR)/$$f ; \
	done
	cp -ur $(INPUT_DIR)/attachments $(OUTPUT_DIR)
	cp -ur $(INPUT_DIR)/attachments $(HOME_DIR)

# Build single master page using space index page.
assemble_document:
	xsltproc $(STYLE_DIR)/index.xsl $(OUTPUT_DIR)/index.html > $(OUTPUT_DOC)

# Convert master page to LaTeX, and combine with formatting rules
build_latex:
	cp -f header.tex output.tex 
	cat $(OUTPUT_DOC) \
		| tidy -xml -indent -utf8 > $(OUTPUT_DOC)2
	java net.sf.saxon.Transform -xsl:$(STYLE_DIR)/latex.xsl -s:$(OUTPUT_DOC)2 \
    	| sed -f filter.sed >> output.tex
	cat footer.tex >> output.tex

# No longer supported
build_xslfo:
	fop -xml $(OUTPUT_DOC) -xsl $(STYLE_DIR)/document.xsl -foout $(OUTPUT_DIR)/$(OUTPUT_NAME).fo

# Run, rerun (build cross-references), display
# If it works the first time, it will work the second time.
build_pdf:
	pdflatex -halt-on-error output.tex
	pdflatex output.tex
	evince output.pdf
