# Copyright (2020) Christoph Neumann

Set-ExecutionPolicy Bypass -Scope Process -Force

iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RefreshEnv

choco feature enable -n stopOnFirstPackageFailure
choco feature enable -n allowGlobalConfirmation 
choco feature enable -n allowEmptyChecksums
choco feature enable -n allowEmptyChecksumsSecure
choco feature enable -n useRememberedArgumentsForUpgrades 

choco install git -y
RefreshEnv

choco install lxrunoffline --limit-output

# install Ubuntu
choco install wsl-ubuntu-1804 --execution-timeout 9999 -y --limit-output
RefreshEnv

wsl --setdefault 'Ubuntu-18.04'

bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y update'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade'

bash -c 'lsb_release -a'

bash -c 'sudo update-locale LANG=en_US.UTF8'

# #########
# fix-broken install
# #########

bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt --fix-broken install'
Write-Host "Edit /var/lib/dpkg/info/libc6\:amd64.postinst"
Write-Host "and comment out the line"
Write-Host "# set -e"
Write-Host "so $ apt-get --fix-broken install can continue."
Write-Host "Press ENTER to continue..."
cmd /c Pause | Out-Null
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt --fix-broken install'

# #########
# add packages
# #########

bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install bash-completion'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install git'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install mc'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install fonts-powerline'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install zip'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install unzip'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install zsh'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install ssh'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install gcc make g++ python'
# PPA Repositories? Install software-properties-common package to get add-apt-repository command!
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common'

bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install default-jre'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive java -version'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive apt-get -y install default-jdk'
bash -c 'sudo  javac -version'

bash -c 'sudo DEBIAN_FRONTEND=noninteractive echo \"JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\" >> /etc/environment'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive echo \"export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\" >> ~/.bashrc'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive echo \"export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\" >> ~/.zshrc'

bash -c "sudo DEBIAN_FRONTEND=noninteractive ssh-keygen -t rsa -P \'\' -f ~/.ssh/id_rsa"
bash -c 'sudo DEBIAN_FRONTEND=noninteractive cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive chmod 0600 ~/.ssh/authorized_keys'
bash -c 'sudo DEBIAN_FRONTEND=noninteractive sudo service ssh restart'

# Hadoop
# https://kontext.tech/column/spark/311/apache-spark-243-installation-on-windows-10-using-windows-subsystem-for-linux
# (Hadoop 3.3 and upper support Java 11) (Hadoop 3.0 to 3.2 supports only Java 8)
# https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions
bash -c 'mkdir ~/hadoop'
bash -c "cd && wget https://ftp.fau.de/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz"
bash -c "cd && tar -xvzf hadoop-3.3.0.tar.gz -C ~/hadoop"
bash -c 'echo \"export HADOOP_HOME=~/hadoop/hadoop-3.3.0\" >> ~/.bashrc'
bash -c 'echo \"export PATH=\$PATH:\$HADOOP_HOME/bin\" >> ~/.bashrc'
bash -c 'cat ~/.bashrc'
