HOME_DIR=$(shell pwd)
OUTPUT_DIR=$(HOME_DIR)/output
STYLE_DIR=$(HOME_DIR)/stylesheets
CONFIG_DIR=$(HOME_DIR)

INTER_XML=$(OUTPUT_DIR)/final.xml

OUTPUT_NAME=output
OUTPUT_FILENAME=$(HOME_DIR)/$(OUTPUT_NAME)
OUTPUT_PDF=$(OUTPUT_FILENAME).pdf
OUTPUT_TEX=$(OUTPUT_FILENAME).tex


INPUT_SPACE=$(shell zipinfo -1 $(SPACE) *index.html)
INPUT_DIR=$(HOME_DIR)/$(dir $(INPUT_SPACE))


all: validate_space open_archive prepare_html assemble_document build_latex build_pdf
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
	xsltproc $(STYLE_DIR)/index.xsl $(OUTPUT_DIR)/index.html > $(INTER_XML)

# Convert master page to LaTeX, and combine with formatting rules
build_latex:
	cp -f header.tex $(OUTPUT_TEX)
	cat $(INTER_XML) \
		| tidy -xml -indent -utf8 > $(INTER_XML)2
	java net.sf.saxon.Transform -xsl:$(STYLE_DIR)/latex.xsl -s:$(INTER_XML)2 \
    	| sed -f filter.sed >> $(OUTPUT_TEX)
	cat footer.tex >> $(OUTPUT_TEX)

# No longer supported
build_xslfo:
	fop -xml $(INTER_XML) -xsl $(STYLE_DIR)/document.xsl -foout $(OUTPUT_DIR)/$(OUTPUT_NAME).fo

# Run, rerun (build cross-references), display
# If it works the first time, it will work the second time.
build_pdf:
	pdflatex -halt-on-error $(OUTPUT_TEX) ; pdflatex $(OUTPUT_TEX) ; evince $(OUTPUT_PDF)



