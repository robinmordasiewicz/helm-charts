# helm-charts

Reference: https://lippertmarkus.com/2020/08/13/chartreleaser/

## Usage

  helm repo add robinmordasiewicz https://robinmordasiewicz.github.io/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
robinmordasiewicz` to see the charts.

To install the jenkins chart:

    helm install jenkins robinmordasiewicz/jenkins

https://www.youtube.com/watch?v=-ykwb1d0DXU
