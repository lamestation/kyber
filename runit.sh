#!/bin/bash

if [ -z "$1" ] ; then
    echo "No space passed!"
    exit
fi

OUTPUT_NAME="output"

HOME_DIR="$(pwd)"
OUTPUT_DIR="${HOME_DIR}/output"
STYLE_DIR="${HOME_DIR}/stylesheets"
CONFIG_DIR="${HOME_DIR}"

OUTPUT_DOC="${OUTPUT_DIR}/final.xml"

INPUT_SPACE="`zipinfo -1 "$1" *index.html`"

INPUT_DIR="${HOME_DIR}/`dirname  $INPUT_SPACE`"

rm -rf $INPUT_DIR
rm -rf $OUTPUT_DIR

unzip "$1"
mkdir -p $OUTPUT_DIR

cd $INPUT_DIR

echo $INPUT_DIR

for f in *.html
do
    ../page.py $f
    sed -i -e '/<META/d' $f
    sed -i -e 's/&nbsp;//g' $f
    tidy -asxml -o ${OUTPUT_DIR}/$f -numeric --force-output yes $f 2>/dev/null
    cp -f $f ${OUTPUT_DIR}/$f
done

cp -ur ${INPUT_DIR}/attachments ${OUTPUT_DIR}/
cp -ur ${INPUT_DIR}/attachments ${HOME_DIR}/

cd ${OUTPUT_DIR}

# Build single master page using space index page.
xsltproc ${STYLE_DIR}/index.xsl index.html > ${OUTPUT_DOC}

cd ${HOME_DIR}


# Convert master page to LaTeX, and combine with formatting rules
cp -f header.tex output.tex 
cat ${OUTPUT_DOC} | tidy -xml -indent -utf8 > ${OUTPUT_DOC}2
xsltproc ${STYLE_DIR}/latex.xsl ${OUTPUT_DOC}2 | sed \
        -e 's/\$/\\$/g' -e 's/&/\\\&/g' \
        -e 's/[ \t]*\././g' -e 's/[ \t]*\,/,/g' \
        >> output.tex # Make sure to clean up special characters for latex
cat footer.tex >> output.tex


#vi output.tex
#        -e 's/^[ \t]*$//e' -e '/./,/^$/!d' \

# Run, rerun (build cross-references), display
pdflatex output.tex ; pdflatex output.tex ; evince output.pdf 
 
#cd ${INPUT_DIR}
##
#fop -xml ${OUTPUT_DOC} -xsl ${STYLE_DIR}/document.xsl -foout ${OUTPUT_DIR}/${OUTPUT_NAME}.fo
#fop -xml ${OUTPUT_DOC} -xsl ${STYLE_DIR}/document.xsl -pdf ${OUTPUT_DIR}/${OUTPUT_NAME}.pdf
##
#cd ..
#
##rm -rf $INPUT_DIR
#
#evince ${OUTPUT_DIR}/${OUTPUT_NAME}.pdf
#
