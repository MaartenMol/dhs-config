sysctl set-hostname ansible-awx.dhsnext.nl
dnf upgrade -y
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf list docker-ce
dnf install docker-ce --nobest -y
systemctl disable firewalld
systemctl start docker
systemctl enable docker
dnf install curl nano -y
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

dnf install python3 -y
dnf install python3-pip -y
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
dnf install ansible -y
ansible --version
dnf install epel-release -y
dnf install git gcc gcc-c++ nodejs gettext device-mapper-persistent-data lvm2 bzip2 python3-pip -y
alternatives --set python /usr/bin/python3
git clone https://github.com/ansible/awx.git