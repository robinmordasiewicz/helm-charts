#!/bin/bash
#

set -e

CHARTVERSION=`cat VERSION.helmchart | sed -re "s/^([0-9]+\.[0-9]+\.[0-9]+)-*[0-9]*/\1/"`
LOCALREVISION=`cat VERSION.helmchart | sed -re "s/^[0-9]+\.[0-9]+\.[0-9]+-*([0-9]*)/\1/" | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}'`

echo "${CHARTVERSION}-${LOCALREVISION}" > VERSION.helmchart

#curl -s https://raw.githubusercontent.com/robinmordasiewicz/jenkins-container/main/VERSION > VERSION.container

[ -d tmp ] && rm -rf tmp
mkdir tmp
git clone https://github.com/robinmordasiewicz/jenkins-container.git tmp/
cp tmp/VERSION VERSION.container
[ -d tmp ] && rm -rf tmp

CONTAINERVERSION=`cat VERSION.container`

cat charts/jenkins/custom-values.yaml | sed -e "s/tag:.*/tag: \"${CONTAINERVERSION}\"/" | sed -e "s/tagLabel:.*/tagLabel: ${CONTAINERVERSION}/" > charts/jenkins/custom-values.yaml.tmp && mv charts/jenkins/custom-values.yaml.tmp charts/jenkins/custom-values.yaml
cat charts/jenkins/custom-values.yaml | sed -e "s/systemMessage:.*/systemMessage: \"JCasC Version: ${CHARTVERSION}-${LOCALREVISION}\"/" > charts/jenkins/custom-values.yaml.tmp && mv charts/jenkins/custom-values.yaml.tmp charts/jenkins/custom-values.yaml

cat charts/jenkins/Chart.yaml | sed -re "s/^version: [0-9]+\.[0-9]+\.[0-9]+-*[0-9]*/version: ${CHARTVERSION}-${LOCALREVISION}/" > charts/jenkins/Chart.yaml.tmp && mv charts/jenkins/Chart.yaml.tmp charts/jenkins/Chart.yaml


