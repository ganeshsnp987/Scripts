#  Scrpits
### 1. Script1 for Java, Jenkins, Docker, SonarQube, Trivy, Helm, Docker-scout

```bash
#!/bin/bash
#install java-17 and jenkins
sudo apt update -y
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y
sudo apt install openjdk-17-jre-headless -y
/usr/bin/java --version
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl start jenkins

#install docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker ubuntu
newgrp docker

# install Sonarqube
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# install trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y

# Install Node.js 16 and npm
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_16.x focal main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt install nodejs -y
sudo apt install npm -y

#install HELM
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

#install Docker-scout
#docker login first then run below command.
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sudo sh -s -- -b /usr/local/bin

# Verify the versions of all installed tools
echo "Verifying installed tools versions:"

echo "Java Version:"
java --version

echo "Jenkins Version:"
jenkins --version

echo "Docker Version:"
docker --version

echo "Docker Compose Plugin Version:"
docker compose version

echo "SonarQube Status (check if it's running):"
docker ps | grep sonar

echo "Trivy Version:"
trivy --version

echo "Node.js Version:"
node -v

echo "npm Version:"
npm -v

echo "Helm Version:"
helm version

echo "Dockr-scout Version:"
docker-scout version

```

### 2. Script 2 for Terraform, kubectl, Aws-cli, Eksctl

```bash
#!/bin/bash
#install terraform
sudo apt install wget -y
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
#install Kubectl on Jenkins
sudo apt update
sudo apt install curl -y
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
#install Aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install unzip -y
unzip awscliv2.zip
sudo ./aws/install

#install Eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# Verify the versions of all installed tools
echo "Verifying installed tools versions:"

echo "Terraform Version:"
terraform version

echo "Kubectl Version:"
kubectl version --client

echo "AWS CLI Version:"
aws --version

echo "eksctl Version:"
eksctl version
```
### 3. Docker Script

```bash
#!/bin/bash

# Update package manager repositories
sudo apt-get update

# Install necessary dependencies
sudo apt-get install -y ca-certificates curl

# Create directory for Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Ensure proper permissions for the key
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package manager repositories
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 4. SonarQube
Community version: Scan Analysis perform only "master" or "main" in branch github repository
```bash
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```
sonarqube-community-branch-plugin: Developer version Perform scan analysis on all branches in github repository
```bash
docker run -d --name sonar -p 9000:9000 mc1arke/sonarqube-with-community-branch-plugin
```

### 5. Installing Jenkins on Ubuntu

```bash
#!/bin/bash

# Install OpenJDK 17 JRE Headless
sudo apt install openjdk-17-jre-headless -y

# Download Jenkins GPG key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository to package manager sources
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package manager repositories
sudo apt-get update

# Install Jenkins
sudo apt-get install jenkins -y
```
### 6. Create Nexus using docker container

```bash
docker run -d --name nexus -p 8081:8081 sonatype/nexus3:latest
```
```
username: admin
password path inside nexus docker container: /opt/sonatype/sonatype-work/nexus3/admin.password
```
### 7. Trivy

```bash
#!/bin/bash
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y
```
### 8. Minikube

```bash
#!/bin/bash

sudo su
apt-get update -y
apt-get upgrade -y
apt-get install net-tools -y

apt-get update -y
apt-get install docker.io -y
systemctl start docker
systemctl enable docker

apt-get update -y
apt install -y curl wget apt-transport-https
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
cp -rvf minikube-linux-amd64 /usr/local/bin/minikube
chmod 755 /usr/local/bin/minikube

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod 755 /usr/local/bin/kubectl

minikube start --force

sudo usermod -aG docker $USER
```
### 9. Ngrok

```bash
#!/bin/bash
# Download ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz

# Extract ngrok
tar -xvzf ngrok-v3-stable-linux-amd64.tgz

# Move ngrok to a directory in your PATH
sudo mv ngrok /usr/local/bin/

# Verify installation
ngrok --version

# (Optional) Connect your ngrok account
ngrok authtoken <your_auth_token>

# Start ngrok
ngrok http 8080
```
### 10. Splunk

```bash
wget -O splunk-9.2.1-78803f08aabb-linux-2.6-amd64.deb "https://download.splunk.com/products/splunk/releases/9.2.1/linux/splunk-9.2.1-78803f08aabb-linux-2.6-amd64.deb"
```
```bash
sudo dpkg -i splunk-9.2.1-78803f08aabb-linux-2.6-amd64.deb
```
```bash
sudo /opt/splunk/bin/splunk enable boot-start
```
The command sudo ufw allow OpenSSH is used to allow incoming SSH traffic through the UFW (Uncomplicated Firewall) on your Ubuntu system. It’s essential for enabling SSH access to your server.
```bash
sudo ufw allow openSSH
```
The command sudo ufw allow 8000 is used to allow incoming network traffic on port 8000 through the UFW (Uncomplicated Firewall) on your Ubuntu system. It permits access to a specific port for network services or applications.
```bash
sudo ufw allow 8000
```
The command sudo ufw allow 8088 is used to allow incoming network traffic on port 8000 through the UFW (Uncomplicated Firewall) on your Ubuntu system. It permits access to a specific port for network services or applications.
```bash
sudo ufw allow 8088
```
By running these commands, you can both check the current status of your firewall and activate it to apply the defined rules and settings.
```bash
sudo ufw enable
sudo ufw status
```
The command sudo /opt/splunk/bin/splunk start is used to start the Splunk Enterprise application on your system. When you run this command with superuser privileges (using sudo), it initiates the Splunk service, allowing you to begin using the Splunk platform for data analysis, monitoring, and other data-related tasks.
```bash
sudo /opt/splunk/bin/splunk start
```
Copy Your Splunk Instance Public IP Address: Navigate to your cloud provider’s console and find the public IP address of your Splunk instance.
Log in with Your Credentials: You’ll be prompted to log in with the administrator username and password you created during the setup process (typically using the command sudo /opt/splunk/bin/splunk enable boot-start).
```bash
<splunk-public-ip:8000>
```

### 10. ARGO-CD SETUP
Let’s Update the kubeconfig<br>
Go to Putty of your Jenkins instance SSH and enter the below command:<br>
aws eks update-kubeconfig --name <CLUSTER NAME> --region <CLUSTER REGION>
```bash
aws eks update-kubeconfig --name EKS_CLOUD --region ap-south-1
```
Let’s install ArgoCD from link (https://archive.eksworkshop.com/intermediate/290_argocd/install)
All those components could be installed using a manifest provided by the Argo Project: use the below commands:
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml
```

By default, argocd-server is not publicly exposed. For this project, we will use a Load Balancer to make it usable:
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
One load balancer will created in the AWS, Wait about 2 minutes for the LoadBalancer creation.


when you run this command, it will export the hostname of the ArgoCD server’s load balancer and store it in the ARGOCD_SERVER environment variable, 
which you can then use in other commands or scripts to interact with the ArgoCD server. This can be useful when you need to access the ArgoCD web UI or 
interact with the server programmatically.
```bash
sudo apt install jq -y
export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname'`
```

If run this command you will get the load balancer external IP:
```bash
echo $ARGOCD_SERVER
```

Login: The command you provided is used to extract the password for the initial admin user of ArgoCD, decode it from base64 encoding, and store it in an environment variable named ARGO_PWD.
```bash
export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
```

If you want to see your password provide the below command:
```bash
echo $ARGO_PWD
```

Now copy the load balancer IP and paste it into the browser
```bash
echo $ARGOCD_SERVER
```

Now you will see Error page. if you get an error click on advanced and click on proceed.
Now you will see log in page to ArgoCD
```bash
Username is admin
```
For the password, you have to provide the below command and copy it.
```bash
echo $ARGO_PWD
```
now, Click on Sign in and you will see this page.<br>
Now click on the Setting gear icon in the left side panel.<br>
Click on Repositories and click on Connect Repo Using HTTPS.<br>
Add Github details, Type as git, Project as default and provide the GitHub URL of this manifest and click on connect.<br>
You will get Connection Status as Successful.<br>
Click on Manage Your application.<br>
You will see page and click on New App. <br>
Now provide the details:<br>
 -  Application name: Your_projectname<br>
 -  Project name: Default<br>
 -  Sync Policy: Automatic<br>
 -  Repo URL: DEPLOYMENT_MANIFEST_URL<br>
 -  Revision: HEAD<br>
 -  Path: ./<br>
 -  Cluster URL: https://kubernetes.default.svc<br>
 -  Namespace: default<br>
Click on Create.<br>
You can see our app is created in Argo-cd. <br>
Click on Project_name and it will create another load balancer in AWS.<br>
Now click on three dots beside Project_name-service and click on the details.<br>
Now copy the hostname address and Paste it in a browser you will see your application is running.<br>

If you don’t get the output
Go to Jenkins machine SSH Putty and provide the below the command:
```bash
kubectl get all
```
Open the port that you see in application-service for the Node group Ec2 instance.
Then you can also see your running application on 
```bash
<Public ip of Node group Ec2 instance>:Port_Number of application service
```

Deletion of Argocd App:
First, delete the app in ARGO CD
Go to Argo CD and click on Application
Click on Delete. Now Provide the app name and click on OK. The app is deleted now.

Now go to Putty and Remove Argo CD Service.
```bash
kubectl delete svc argocd-server -n argocd
```
Now you can see in the Aws console that load balancers will be deleted.


### 11. Ingress-controller-NGINX
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml
```
### 12. Install EKS

Please follow the prerequisites doc before this.

## Install a EKS cluster with EKSCTL

```
# Download and extract the latest release of eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

# Move the binary to a directory in your PATH
sudo mv /tmp/eksctl /usr/local/bin

# Verify the installation
eksctl version
eksctl create cluster --name demo-cluster --region us-east-1 
```

## Delete the cluster

```
eksctl delete cluster --name demo-cluster --region us-east-1
```

### 13. Install Argo CD

## Install Argo CD using manifests

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Access the Argo CD UI (Loadbalancer service) 

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

## Get the Loadbalancer service IP

```bash
kubectl get svc argocd-server -n argocd
```
### 14. EKS COMLETE
## First Create a user in AWS IAM with any name
## Attach Policies to the newly created user
## below policies
AmazonEC2FullAccess

AmazonEKS_CNI_Policy

AmazonEKSClusterPolicy	

AmazonEKSWorkerNodePolicy

AWSCloudFormationFullAccess

IAMFullAccess

#### One more policy we need to create with content as below
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        }
    ]
}
```
Attach this policy to your user as well

![Policies To Attach](https://github.com/jaiswaladi246/EKS-Complete/blob/main/Policies.png)

# AWSCLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws configure
```

## KUBECTL

```bash
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

## EKSCTL

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

## Create EKS CLUSTER

```bash
eksctl create cluster --name=my-eks22 \
                      --region=ap-south-1 \
                      --zones=ap-south-1a,ap-south-1b \
                      --without-nodegroup

eksctl utils associate-iam-oidc-provider \
    --region ap-south-1 \
    --cluster my-eks22 \
    --approve

eksctl create nodegroup --cluster=my-eks22 \
                       --region=ap-south-1 \
                       --name=node2 \
                       --node-type=t3.medium \
                       --nodes=3 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=Key \
                       --managed \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access
```

* Open INBOUND TRAFFIC IN ADDITIONAL Security Group
* Create Servcie account/ROLE/BIND-ROLE/Token

## Create Service Account, Role & Assign that role, And create a secret for Service Account and geenrate a Token
first we need to create namespace
```
kubectl create ns webapps
```

### Creating Service Account: sa.yaml


```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: webapps
```

### Create Role: role.yaml


```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-role
  namespace: webapps
rules:
  - apiGroups:
        - ""
        - apps
        - autoscaling
        - batch
        - extensions
        - policy
        - rbac.authorization.k8s.io
    resources:
      - pods
      - secrets
      - componentstatuses
      - configmaps
      - daemonsets
      - deployments
      - events
      - endpoints
      - horizontalpodautoscalers
      - ingress
      - jobs
      - limitranges
      - namespaces
      - nodes
      - pods
      - persistentvolumes
      - persistentvolumeclaims
      - resourcequotas
      - replicasets
      - replicationcontrollers
      - serviceaccounts
      - services
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
```

### Bind the role to service account: rolebind.yaml


```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-rolebinding
  namespace: webapps 
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: app-role 
subjects:
- namespace: webapps 
  kind: ServiceAccount
  name: jenkins 
```

### Generate token using service account in the namespace: secret.yaml


```yaml
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: mysecretname
  annotations:
    kubernetes.io/service-account.name: jenkins
```
```
kubectl apply -f secret.yaml -n webapps
```
```
kubectl describe secret mysecretname -n webapps
```
You will get token here [Create Token](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/#:~:text=To%20create%20a%20non%2Dexpiring,with%20that%20generated%20token%20data.)
Put this token in Manage jenkins-->credential section as secret text. So k8s interact with jenkins


### 15. Install Prometheus and Grafana On the new Server:
To create a system user or system account, run the following command:
```bash
sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false prometheus
```
Let’s check the latest version of Prometheus from the [download page](https://prometheus.io/download/).
You can use the curl or wget command to download Prometheus:
```bash
wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz
```
Then, we need to extract all Prometheus files from the archive:
```bash
tar -xvf prometheus-2.47.1.linux-amd64.tar.gz
```
Usually, you would have a disk mounted to the data directory. For this tutorial, I will simply create a /data directory. Also, you need a folder for Prometheus configuration files:
```bash
sudo mkdir -p /data /etc/prometheus
```
Now, let’s change the directory to Prometheus and move some files.
```bash
cd prometheus-2.47.1.linux-amd64/
```
First of all, let’s move the Prometheus binary and a promtool to the /usr/local/bin/. promtool is used to check configuration files and Prometheus rules:
```bash
sudo mv prometheus promtool /usr/local/bin/
```
Optionally, we can move console libraries to the Prometheus configuration directory. Console templates allow for the creation of arbitrary consoles using the Go templating language. You don’t need to worry about it if you’re just getting started:
```bash
sudo mv consoles/ console_libraries/ /etc/prometheus/
```
Finally, let’s move the example of the main Prometheus configuration file:
```bash
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
```
To avoid permission issues, you need to set the correct ownership for the /etc/prometheus/ and data directory:
```bash
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/
```
You can delete the archive and a Prometheus folder when you are done:
```bash
cd
rm -rf prometheus-2.47.1.linux-amd64.tar.gz
```
Verify that you can execute the Prometheus binary by running the following command:
```bash
prometheus --version
```
To get more information and configuration options, run Prometheus Help:
```bash
prometheus --help
```
We’re going to use some of these options in the service definition.
We’re going to use Systemd, which is a system and service manager for Linux operating systems. For that, we need to create a Systemd unit configuration file:
```bash
sudo vim /etc/systemd/system/prometheus.service
```
Prometheus.service
```bash
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5
[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle
[Install]
WantedBy=multi-user.target
```
To automatically start the Prometheus after reboot, run enable:
```bash
sudo systemctl enable prometheus
```
Then just start the Prometheus:
```bash
sudo systemctl start prometheus
```
To check the status of Prometheus run the following command:
```bash
sudo systemctl status prometheus
```
Suppose you encounter any issues with Prometheus or are unable to start it. The easiest way to find the problem is to use the journalctl command and search for errors:
```bash
journalctl -u prometheus -f --no-pager
```
Now we can try to access it via the browser. I’m going to be using the IP address of the Ubuntu server. You need to append port 9090 to the IP:
```bash
<public-ip:9090>
```
If you go to targets, you should see only one – Prometheus target. It scrapes itself every 15 seconds by default.



### 16. Install Node Exporter on Ubuntu 22.04

Next, we’re going to set up and configure Node Exporter to collect Linux system metrics like CPU load and disk I/O. Node Exporter will expose these as Prometheus-style metrics. Since the installation process is very similar, I’m not going to cover as deep as Prometheus.
First, let’s create a system user for Node Exporter by running the following command:
```bash
sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false node_exporter
```
You can download [Node Exporter](https://prometheus.io/download/) from the same page.
Use the wget command to download the binary:
```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
```
Extract the node exporter from the archive:
```bash
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz
```
Move binary to the /usr/local/bin
```bash
sudo mv \
  node_exporter-1.6.1.linux-amd64/node_exporter \
  /usr/local/bin/
```
Clean up, and delete node_exporter archive and a folder:
```bash
rm -rf node_exporter*
```
Verify that you can run the binary:
```bash
node_exporter --version
```
Node Exporter has a lot of plugins that we can enable. If you run Node Exporter help you will get all the options:
```bash
node_exporter --help
```
Next, create a similar systemd unit file:
```bash
sudo vim /etc/systemd/system/node_exporter.service
```
node_exporter.service
```bash
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5
[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter \
    --collector.logind
[Install]
WantedBy=multi-user.target
```
Replace Prometheus user and group to node_exporter, and update the ExecStart command.

To automatically start the Node Exporter after reboot, enable the service:
```bash
sudo systemctl enable node_exporter
```
Check the status of Node Exporter with the following command:
```bash
sudo systemctl status node_exporter
```
If you have any issues, check logs with journalctl:
```bash
journalctl -u node_exporter -f --no-pager
```
At this point, we have only a single target in our Prometheus. There are many different service discovery mechanisms built into Prometheus. For example, Prometheus can dynamically discover targets in AWS, GCP, and other clouds based on the labels. In the following tutorials, I’ll give you a few examples of deploying Prometheus in a cloud-specific environment. For this tutorial, let’s keep it simple and keep adding static targets. Also, I have a lesson on how to deploy and manage Prometheus in the Kubernetes cluster.

To create a static target, you need to add job_name with static_configs:
```bash
sudo vim /etc/prometheus/prometheus.yml
```
prometheus.yml
```bash
- job_name: node_export
    static_configs:
      - targets: ["localhost:9100"]
```
By default, Node Exporter will be exposed on port 9100.
Since we enabled lifecycle management via API calls, we can reload the Prometheus config without restarting the service and causing downtime.
Before, restarting check if the config is valid:
```bash
promtool check config /etc/prometheus/prometheus.yml
```
Then, you can use a POST request to reload the config:
```bash
curl -X POST http://localhost:9090/-/reload
```
Check the targets section:
```bash
http://<your-prometheus ip>:9090/targets
```
### 17. Install Grafana on Ubuntu 22.04
To visualize metrics we can use Grafana. There are many different data sources that Grafana supports, one of them is Prometheus.
First, let’s make sure that all the dependencies are installed:
```bash
sudo apt-get install -y apt-transport-https software-properties-common
```
Next, add the GPG key:
```bash
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
```
Add this repository for stable releases:
```bash
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```
After you add the repository, update and install Garafana:
```bash
sudo apt-get update -y
sudo apt-get -y install grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server
```
Go to http://<ip>:3000 and log in to the Grafana using default credentials. The username is admin, and the password is admin as well.
```bash
username admin
password admin
```
To visualize metrics, you need to add a data source first. Click Add data source and select Prometheus.For the URL, enter localhost:9090 and click Save and test. You can see Data source is working. Click on Save and Test. Let’s add Dashboard for a better view. Click on Import Dashboard paste this code 1860 and click on load. Select the Datasource and click on Import. You will see this output








