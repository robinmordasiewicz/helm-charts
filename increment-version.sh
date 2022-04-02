#!/bin/bash
#

CHARTVERSION=`cat VERSION.helmchart | sed -re "s/^([0-9]+\.[0-9]+\.[0-9]+)-*[0-9]*/\1/"`
LOCALREVISION=`cat VERSION.helmchart | sed -re "s/^[0-9]+\.[0-9]+\.[0-9]+-*([0-9]*)/\1/" | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}'`
echo "${CHARTVERSION}-${LOCALREVISION}" > VERSION.helmchart


CONTAINERVERSION=`cat VERSION.container`

cat values.yaml | sed -re "s/(tag:) \"[0-9]*\.[0-9]*\.[0-9]*-[0-9]*\"/\1 \"${CONTAINERVERSION}\"/" | sed -re "s/(tagLabel:) [0-9]*\.[0-9]*\.[0-9]*-[0-9]*/\1 ${CONTAINERVERSION}/" > values.yaml.tmp && mv values.yaml.tmp values.yaml
