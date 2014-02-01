#!/bin/bash

HOME_DIR="$(pwd)"
INPUT_DIR="${HOME_DIR}/LM"
OUTPUT_DIR="${HOME_DIR}/output"
OUTPUT_DOC="${HOME_DIR}/finaldoc.xml"

mkdir -p $OUTPUT_DIR

cd $INPUT_DIR

for f in *.html
do
    ../page.py $f
#    sed -i -e '/<!DOCTYPE/d' $f
    sed -i -e '/<META/d' $f
    sed -i -e 's/&nbsp;//g' $f
    tidy -asxml -o ${OUTPUT_DIR}/$f -numeric --force-output yes $f 2>/dev/null
 #   sed -i -e '/<title>/ s/\(<title>\)[^:]*:\(.*<\/title>\)/\1\2/g' $1
    cp -f $f ${OUTPUT_DIR}/$f
done

cp -ur ${INPUT_DIR}/attachments ${OUTPUT_DIR}/

cd ${OUTPUT_DIR}

xsltproc ${HOME_DIR}/index.xsl index.html > ${OUTPUT_DOC}

cd ${INPUT_DIR}

fop -xml ${OUTPUT_DOC} -xsl ${HOME_DIR}/document.xsl -pdf ../output.pdf

cd ..
evince output.pdf

#fop -xml ${OUTPUT_DOC} -xsl lm.xsl -foout output.fo  ; vi output.fo #
