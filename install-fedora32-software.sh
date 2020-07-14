# Goda!

read -p "Check your network and wireless..."

read -p "Check your bluetooth and setup headphones. And if bluetooth does not work, just run the updates. It will start working. Are you done?"

read -p "You have to adjust your monitor to setup dual monitor..."

echo "Update repos..."
sudo dnf update

echo "Install wget"
sudo dnf install wget

echo "Install powertop - monitor battery..."
sudo dnf install powertop

echo "Set monitor brightness"

echo "Setup sdkman..."
curl -s "https://get.sdkman.io" | bash
source "/home/godav/.sdkman/bin/sdkman-init.sh"
sdk version

echo "Install java11...."
sdk install java 11.0.7-open

echo "installing graalvm..."
sdk install java 20.1.0.r8-grl
sdk use java 20.1.0.r8-grl
gu install native-image

echo "Revert back to java 11"
sdk use java 11.0.7-open

echo "python3 is already installed..."

echo "install node and npm... (in fedora npm gets installed along with node. But its LTS version not the 14.X version (Latest version)"
sudo dnf install nodejs

echo "Installing virtualbox.... (https://computingforgeeks.com/how-to-install-vagrant-and-virtualbox-on-fedora/)"
sudo dnf -y install wget
wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
sudo mv virtualbox.repo /etc/yum.repos.d/virtualbox.repo
sudo dnf install -y gcc binutils make glibc-devel patch libgomp glibc-headers  kernel-headers kernel-devel-`uname -r` dkms
sudo dnf install -y VirtualBox-6.1


echo "Install docker and setup permissions (specific to fedora source: https://fedoramagazine.org/docker-and-fedora-32/)"
sudo dnf remove docker-*
sudo dnf config-manager --disable docker-*
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0
sudo firewall-cmd --permanent --zone=FedoraWorkstation --add-masquerade
sudo dnf install moby-engine docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo chmod 777 /var/run/docker.sock
docker run hello-world

echo "Install minikube..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

echo "Start the minikube"
minikube start --memory=16384 --cpus=4 --kubernetes-version=v1.18.3 --driver=virtualbox

echo "Installing tmux..."
sudo dnf install tmux

echo "Install htop"
sudo dnf install htop

echo "Install powertop - monitor battery..."
sudo dnf install powertop

echo "Installing micronaut..."
sdk update
sdk install micronaut

echo "Installing kubectl..."
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version

echo "Install metallb..."
minikube_ip=$(minikube ip)
echo "The minikube ip is"
echo $minikube_ip
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.99.150-192.168.99.200
EOF



echo "Installing istio - https://istio.io/latest/docs/setup/getting-started/"
cd /opt
sudo curl -L https://istio.io/downloadIstio | sudo sh -
sudo chmod -R 755 istio-1.6.5
cd istio-1.6.5/bin
sudo mv istioctl /usr/local/bin
istioctl
istioctl install --set profile=demo --set components.telemetry.enabled=true --set components.citadel.enabled=true
echo "Verifying the metallb installation..."
kubectl get all -n istio-system
read -p "Do you see the IP in the ingress gateway?"

echo "Installing tree....."
sudo dnf install tree

echo "Installing VS Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install code

echo "Installing intellij... via snaps"
read -p "Download and install it from https://www.jetbrains.com/help/idea/installation-guide.html#standalone"



echo "Installing maven"
sudo dnf install maven

read -p "Have you done setting up credentials? the font? jdk for one of the projects? maven depdencies? Done?"

#echo "Install google chrome ..."
sudo dnf install google-chrome-stable

#echo "gem is already installed..."

echo "install helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

echo "install vagrant..."
sudo dnf install vagrant

echo "install terraform..."
curl -o terraform.zip  https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
unzip terraform.zip
sudo chmod +x terraform
sudo mv terraform /usr/local/bin

echo "install vim..."
sudo dnf install vim

echo "Install homebrew to install sam cli..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
brew --version
brew tap aws/tap
brew install aws-sam-cli
brew upgrade aws/tap/aws-sam-cli
sam --version

echo "installing aws-cli ...."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

echo "Installing terminator..."
sudo dnf install terminator
sudo dnf install figlet

read -p "Styles and colors on terminator. Done?"
read -p "Add figet command to .bashrc (sometimes it is in /etc/skel. Not sure if something is wrong with this). Done?"

read "Setting up git credentials..."
git config --global credential.helper store
read -p "Setup github credentials... Done?"
#git config --global user.name "<UserName>"
#git config --global user.email "<Email>"



read -p "Add your software to favorites... Done?"

read -p "Done setting up the google drive accounts?"

echo "Dbeaver database client..."
wget https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm
sudo rpm -Uvh ./dbeaver-ce-latest-stable.x86_64.rpm

#echo "Insalling network tools (net-tools)...."
sudo dnf install net-tools

read -p "Download and install google chrome..."

read -p "Install timeshift..."

read -p "Install gnome boxes..."

read -p "Install kdenlive from snaps..."

read -p "Install kde connect from repos..."

read -p "Install RPM fusion repo - both free and non free" 

echo "Make alt+tab show windows only from current workspace"
gsettings set org.gnome.shell.app-switcher current-workspace-only true

