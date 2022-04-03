#!/bin/bash
#

set -e

CHARTVERSION=`cat VERSION.helmchart | sed -re "s/^([0-9]+\.[0-9]+\.[0-9]+)-*[0-9]*/\1/"`
LOCALREVISION=`cat VERSION.helmchart | sed -re "s/^[0-9]+\.[0-9]+\.[0-9]+-*([0-9]*)/\1/"`
CONTAINERVERSION=`cat VERSION.container`

if [ -d tmp ]
then
  rm -rf tmp && mkdir tmp
else
  mkdir tmp
fi

helm repo rm jenkins || true
helm repo add jenkins https://charts.jenkins.io
helm pull jenkins/jenkins --version ${CHARTVERSION} -d tmp/
helm repo rm jenkins

tar -zxvf tmp/jenkins-${CHARTVERSION}.tgz -C tmp/

cp custom-values.yaml tmp/jenkins/

cat tmp/jenkins/Chart.yaml | sed -re "s/^version: [0-9]+\.[0-9]+\.[0-9]+-*[0-9]*/version: ${CHARTVERSION}-${LOCALREVISION}/" > tmp/jenkins/Chart.yaml.tmp && mv tmp/jenkins/Chart.yaml.tmp tmp/jenkins/Chart.yaml

helm lint tmp/jenkins/ -f tmp/jenkins/custom-values.yaml --strict

(cd -- "tmp" && helm package jenkins --version "${CHARTVERSION}-${LOCALREVISION}" -d ../ --app-version ${CONTAINERVERSION} )

if [ -d tmp ]
then
  rm -rf tmp
fi

#helm repo index --url https://robinmordasiewicz.github.io/helm-charts .
