#!/usr/bin/env bash

# Author: manzolo

PrerequisitesInstall() {
	printf "Installing Prerequisites\n"
	apt update -qqy
	apt install wget git python3 python3-pip python3-tk libxrender1 libxtst6 libxi6 libxtst6 -y
	git --version
}

# Install JDK21
JDKInstall() {
	printf "Installing 21\n"
	printf "\n Enter your Password then Sit back and Relax\n"
	apt update -qqy
	apt install openjdk-21-jdk openjdk-21-jre -y
	printf "\n Setting Java Path Variable\n"
	export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
	printf "\n Testing JAVA_HOME Path\n"
	echo $JAVA_HOME
	printf "\n Adding JAVA bin directory to the PATH variable\n"
	export PATH=$PATH:$JAVA_HOME/bin
	printf "\n Testing PATH Variable\n"
	echo $PATH
	printf "\n Testing Java Installation\n"
	java -version
}

# Download Android Studio
DownloadPycharm() {
	echo "\n Downloading Pycharm \n"
	wget -c "https://download.jetbrains.com/python/pycharm-community-2024.3.1.1.tar.gz"
}

# Install Pycharm
InstallPycharm() {
	echo "\n Installing Pycharm \n"
	tar -xzf pycharm-community-2024.3.1.1.tar.gz -C /opt

	mkdir -p "$HOME"/.local/share/applications
	cat >"$HOME"/.local/share/applications/pycharm.desktop <<-EOF
		[Desktop Entry]
		Version=2024.2.2.13
		Type=Application
		Name=Pycharm Community
		Exec="/opt/pycharm-community-2024.3.1.1/bin/pycharm.sh" %f
		Icon=/opt/pycharm-community-2024.3.1.1/bin/pycharm.png
		Categories=Development;IDE;
		Terminal=false
		StartupNotify=true
		StartupWMClass=pycharm
	EOF

	chmod +x "$HOME"/.local/share/applications/pycharm-community.desktop

	echo "\n Installing Finished \n"
	rm -rf installer.sh
	rm -rf pycharm-community-2024.3.1.1.tar.gz
	rm -rf /var/lib/apt/lists/*
}

PrerequisitesInstall
JDKInstall
#DownloadPycharm
InstallPycharm

