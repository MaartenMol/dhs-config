![](https://img.maartenmol.nl/test.png) ![](https://img.maartenmol.nl/test2.png)
# nextCloud Infrastructure as Code (IaC) Powered By DHS
## Make sure the following DNS A records exist:
* ansible-awx -> 172.27.72.60
* docker-01 -> 172.27.72.61
* docker-02 -> 172.27.72.62
* docker-03 -> 172.27.72.63
* lb-01 -> 172.27.72.65
* lb-02 -> 172.27.72.66
* hophop -> 172.27.72.69
* vip, grafana, awx, portainer, karma, kibana -> 172.27.72.67

## Start deployment with Terraform
````terraform apply -var="vsphere-password=P@ssword"````
