# Goda!

read -p "Check your network and wireless:"

read -p "Check your bluetooth and setup headphones. And if bluetooth does not work, just run the updates. It will start working. Are you done?"

read -p "You have to adjust your monitor to setup dual monitor:"

echo "Update repos..."
sudo dnf update

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

echo "Install docker and setup permissions (specific to fedora source: https://fedoramagazine.org/docker-and-fedora-32/)"
sudo dnf remove docker-*
sudo dnf config-manager --disable docker-*
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0
sudo firewall-cmd --permanent --zone=FedoraWorkstation --add-masquerade
sudo dnf install moby-engine docker-compose
sudo chmod 777 /var/run/docker.sock
sudo systemctl enable docker
docker run hello-world

echo "Installing virtualbox. Download and install VirtualBox from the website (Will give you an RPM Package)"

echo "Install minikube..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

echo "Start the minikube"
minikube start --memory=16384 --cpus=4 --kubernetes-version=v1.18.3 --driver=virtualbox

# Discontinued after this since fedora failed on virtualbox because of missing kernel headers. I could have fixed it, but just moved on. I dont care.
