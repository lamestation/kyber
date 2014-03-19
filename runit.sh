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

#rm -rf $INPUT_DIR
#rm -rf $OUTPUT_DIR

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

cd ${OUTPUT_DIR}

xsltproc ${STYLE_DIR}/index.xsl index.html > ${OUTPUT_DOC}

cd ${INPUT_DIR}

fop -xml ${OUTPUT_DOC} -xsl ${STYLE_DIR}/document.xsl -foout ${OUTPUT_DIR}/${OUTPUT_NAME}.fo
fop -c ${CONFIG_DIR}/config.xml -xml ${OUTPUT_DOC} -xsl ${STYLE_DIR}/document.xsl -pdf ${OUTPUT_DIR}/${OUTPUT_NAME}.pdf

cd ..

#rm -rf $INPUT_DIR

evince ${OUTPUT_DIR}/${OUTPUT_NAME}.pdf

