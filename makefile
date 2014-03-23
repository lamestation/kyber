OUTPUT_NAME="output"

HOME_DIR=$(shell pwd)
OUTPUT_DIR=$(HOME_DIR)/output
STYLE_DIR=$(HOME_DIR)/stylesheets
CONFIG_DIR=$(HOME_DIR)

OUTPUT_DOC=$(OUTPUT_DIR)/final.xml

INPUT_SPACE=$(shell zipinfo -1 $(SPACE) *index.html)
INPUT_DIR=$(HOME_DIR)/$(dir $(INPUT_SPACE))



all: validate_space open_archive prepare_html
	@echo $(SPACE)
	@echo $(INPUT_SPACE)
	@echo $(INPUT_DIR)


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

prepare_html:
	echo $(INPUT_DIR)
	for f in *.html ; \
	do \
		./page.py $(INPUT_DIR)/$f ; \
		sed -i -e '/<META/d' $(INPUT_DIR)/$f ; \
		sed -i -e 's/&nbsp;//g' $(INPUT_DIR)/$f ; \
		tidy -asxml -o $(OUTPUT_DIR)/$f -numeric --force-output yes $(INPUT_DIR)/$f 2>/dev/null ; \
		cp -f $(INPUT_DIR)/$f $(OUTPUT_DIR)/$f ; \
	done
	cp -ur $(INPUT_DIR)/attachments $(OUTPUT_DIR)/
	cp -ur $(INPUT_DIR)/attachments $(HOME_DIR)/

