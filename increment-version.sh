#!/bin/bash
#

cat VERSION | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}' > VERSION.tmp && mv VERSION.tmp VERSION

version=`cat VERSION`

cat charts/jenkins/Chart.yaml | sed -re "s/^version: ([0-9]+\.[0-9]+\.[0-9]+)/version: \1-${version}/" > charts/jenkins/Chart.yaml.tmp && mv charts/jenkins/Chart.yaml.tmp charts/jenkins/Chart.yaml

#cat VERSION
