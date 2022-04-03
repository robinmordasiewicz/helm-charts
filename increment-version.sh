#!/bin/bash
#

set -e

CHARTVERSION=`cat VERSION.helmchart | sed -re "s/^([0-9]+\.[0-9]+\.[0-9]+)-*[0-9]*/\1/"`
LOCALREVISION=`cat VERSION.helmchart | sed -re "s/^[0-9]+\.[0-9]+\.[0-9]+-*([0-9]*)/\1/" | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}'`

echo "${CHARTVERSION}-${LOCALREVISION}" > VERSION.helmchart

curl -s https://raw.githubusercontent.com/robinmordasiewicz/jenkins-container/main/VERSION > VERSION.container

CONTAINERVERSION=`cat VERSION.container`

cat custom-values.yaml | sed -e "s/tag:.*/tag: \"${CONTAINERVERSION}\"/" | sed -e "s/tagLabel:.*/tagLabel: ${CONTAINERVERSION}/" > custom-values.yaml.tmp && mv custom-values.yaml.tmp custom-values.yaml

