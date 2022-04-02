# helm-charts

## Usage

  helm repo add robinmordasiewicz https://robinmordasiewicz.github.io/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
robinmordasiewicz` to see the charts.

To install the jenkins chart:

    helm install jenkins robinmordasiewicz/jenkins

To uninstall the chart:

    helm delete jenkins


## manual install
 
   helm repo remove robinmordasiewicz

   helm repo add jenkins https://charts.jenkins.io

   helm repo update

   helm install jenkins -n r-mordasiewicz -f values.yaml jenkins/jenkins
