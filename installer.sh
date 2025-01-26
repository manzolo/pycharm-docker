#!/usr/bin/env bash

# Author: manzolo
PrerequisitesInstall() {
	printf "Installing Prerequisites\n"
	apt update -qqy
	apt install wget git python3 python3-pip python3-tk libxrender1 libxtst6 libxi6 libxtst6 libcanberra-gtk-module libcanberra-gtk3-module -y
	git --version
}

# Install Firefox
FirefoxInstall() {
	printf "Installing Firefox\n"
	install -d -m 0755 /etc/apt/keyrings
	wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
	echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
	echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1' | tee /etc/apt/preferences.d/mozilla

apt update && apt remove firefox && apt install -y firefox

}

# Install JDK21
JDKInstall() {
	printf "Installing JDK21\n"
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
	wget -c "https://download.jetbrains.com/python/pycharm-community-"${PYCHARM_VERSION}".tar.gz"
}

# Install Pycharm
InstallPycharm() {
	echo "\n Installing Pycharm \n"
	tar -xzf pycharm-community-${PYCHARM_VERSION}.tar.gz -C /opt
	mv /opt/pycharm-community-${PYCHARM_VERSION} /opt/pycharm-community

	mkdir -p /home/${CONTAINER_USERNAME}/.local/share/applications
	mkdir -p /home/${CONTAINER_USERNAME}/.config
	mkdir -p /home/${CONTAINER_USERNAME}/.java/.userPrefs/jetbrains	
	cat >/home/${CONTAINER_USERNAME}/.local/share/applications/pycharm-community.desktop <<-EOF
		[Desktop Entry]
		Version=${PYCHARM_VERSION}
		Type=Application
		Name=Pycharm Community
		Exec="/opt/pycharm-community/bin/pycharm.sh" %f
		Icon=/opt/pycharm-community/bin/pycharm.png
		Categories=Development;IDE;
		Terminal=false
		StartupNotify=true
		StartupWMClass=pycharm
	EOF

	chmod +x /home/${CONTAINER_USERNAME}/.local/share/applications/pycharm-community.desktop
	chown -R ${CONTAINER_USERNAME}:${CONTAINER_USERNAME} /home/${CONTAINER_USERNAME}
	echo "\n Installing Finished \n"
	rm -rf installer.sh
	rm -rf pycharm-community-${PYCHARM_VERSION}.tar.gz
	rm -rf /var/lib/apt/lists/*
}

PrerequisitesInstall
FirefoxInstall
JDKInstall
DownloadPycharm
InstallPycharm

