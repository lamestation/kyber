HOME_DIR=$(shell pwd)
STYLE_DIR=$(HOME_DIR)/xsl
SED_DIR=$(HOME_DIR)/sed
TEX_DIR=$(HOME_DIR)/tex

INTER_XML=$(INPUT_DIR)/final.xml

OUTPUT_NAME=output
OUTPUT_DIR=$(HOME_DIR)/$(OUTPUT_NAME)
OUTPUT_FILENAME=$(OUTPUT_DIR)/$(OUTPUT_NAME)
OUTPUT_PDF=$(OUTPUT_FILENAME).pdf
OUTPUT_TEX=$(OUTPUT_FILENAME).tex
OUTPUT_IDX=$(OUTPUT_NAME).idx

HTML_OUT=$(OUTPUT_DIR)/manual


INPUT_SPACE=$(shell zipinfo -1 $(SPACE) *index.html)
INPUT_DIR=$(HOME_DIR)/$(dir $(INPUT_SPACE))

TEX_ENGINE=xelatex

export CLASSPATH=/usr/share/java/saxonb.jar


all:
	@echo "Choose something to build!"
	@echo ""
	@echo "    make [pdf,site] SPACE=name.zip"
	@echo ""
	@echo $(SPACE)
	@echo $(INPUT_SPACE)
	@echo $(INPUT_DIR)


pdf: view_pdf
site: build_website



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
	mkdir -p download $(INPUT_DIR)/download
	rm $(HOME_DIR)/attachments
	ln -sf $(INPUT_DIR)/attachments download/attachments
	ln -sf $(INPUT_DIR)/attachments attachments
	ln -sf $(INPUT_DIR)/attachments $(INPUT_DIR)/download/attachments

# Build single master page using space index page.
assemble_singledocument: prepare_html
	java net.sf.saxon.Transform -xsl:$(STYLE_DIR)/index.xsl -s:$(INPUT_DIR)/index.html > $(INTER_XML)

# Generate Jekyll-friendly web pages for online book
build_website: prepare_html
	mkdir -p $(HTML_OUT)
	cd $(INPUT_DIR) ; \
	for f in *.html ; \
	do \
		echo $(INPUT_DIR)/$$f ; \
		xsltproc $(STYLE_DIR)/html.xsl $(INPUT_DIR)/$$f > $(HTML_OUT)/$$f ; \
		sed -n '/[^ \t]/p' -i $(HTML_OUT)/$$f ; \
	done ; \
	echo "---\nlayout: manpage\ntitle: Manual\n---" > $(HTML_OUT)/index.html ; \
	xsltproc $(STYLE_DIR)/navbar.xsl $(INPUT_DIR)/index.html >> $(HTML_OUT)/index.html ; \
	sed -n '/[^ \t]/p' -i $(HTML_OUT)/index.html
	cp -ur $(INPUT_DIR)/attachments $(HTML_OUT)


# Convert master page to LaTeX, and combine with formatting rules
build_latex: assemble_singledocument
	mkdir $(OUTPUT_DIR) -p
	cp -f $(TEX_DIR)/header.tex $(OUTPUT_TEX)
	cat $(INTER_XML) \
		| tidy -xml -indent -utf8 > $(INTER_XML)2
	java net.sf.saxon.Transform -xsl:$(STYLE_DIR)/latex.xsl -s:$(INTER_XML)2 > tmp.1
	sed -f $(SED_DIR)/output.sed tmp.1 >> $(OUTPUT_TEX)
	rm tmp.1
	cat $(TEX_DIR)/footer.tex >> $(OUTPUT_TEX)

# Run, rerun (build cross-references), display
# If it works the first time, it will work the second time.
build_pdf: build_latex
	$(TEX_ENGINE) -halt-on-error -aux-directory=$(OUTPUT_DIR) -output-directory=$(OUTPUT_DIR) $(OUTPUT_TEX)
	cd $(OUTPUT_DIR) ; makeindex $(OUTPUT_IDX)
	$(TEX_ENGINE) -halt-on-error -aux-directory=$(OUTPUT_DIR) -output-directory=$(OUTPUT_DIR) $(OUTPUT_TEX)

finalize_pdf: build_pdf
	gs -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$(OUTPUT_FILENAME).small.pdf $(OUTPUT_PDF)

view_pdf: build_pdf
	evince $(OUTPUT_PDF)


clean:
	rm $(HOME_DIR)/attachments
	rm -rf $(HOME_DIR)/attachments/
