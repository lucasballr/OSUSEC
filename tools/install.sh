#!/bin/sh

set -e

APT_PACKAGES="python3 python3-pip npm gdb curl vim ruby"
GEM_PACKAGES="one_gadget"
PIP_PACKAGES="pwntools scapy"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

log "Installing new packages via apt"
for pkg in $APT_PACKAGES; do
	if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
		echo -e "${YELLOW}[APT] $pkg is already installed ${ENDCOLOR}"
	else
		if sudo -E apt-get install -y $pkg; then
			echo -e "${GREEN}[APT] Successfully installed $pkg ${ENDCOLOR}"
		else
			echo -e "${RED}[APT] Error installing $pkg ${ENDCOLOR}"
		fi
	fi
done

log "Installing gem packages"
for pkg in $GEM_PACKAGES; do
	if [ ! `gem list '^$pkg$' -i >/dev/null` ]; then
		echo -e "${YELLOW}[GEM] $pkg is already installed ${ENDCOLOR}"
	else
		if sudo gem install $pkg; then
			echo -e "${GREEN}[GEM] Successfully installed $pkg ${ENDCOLOR}"
		else
			echo -e "${RED}[GEM] Error installing $pkg ${ENDCOLOR}"
		fi
	fi
done

log "Upgrading pip"
pip3 install --upgrade pip

log "Creating virtualenv"
python3 -m pip install virtualenv
python3 -m virtualenv ~/pyenv
source ~/pyenv/bin/activate

log "Installing pip packages"
for pkg in $PIP_PACKAGES; do
	if pip freeze | grep -iq "^$pkg=" >/dev/null; then
		echo -e "${YELLOW}[PIP] $pkg is already installed ${ENDCOLOR}"
	else
		if python3 -m pip install $pkg; then
			echo -e "${GREEN}[PIP] Successfully installed $pkg ${ENDCOLOR}"
		else
			echo -e "${RED}[PIP] Error installing $pkg ${ENDCOLOR}"
		fi
	fi
done


log "Configuring gdb"
if [ ! -d "$HOME/.pwndbg" ]; then
	git clone https://github.com/pwndbg/pwndbg ~/.pwndbg
	cd ~/.pwndbg
	chmod +x setup.sh
	./setup.sh
else
	echo -e "${YELLOW}[GDB] pwndbg is already installed ${ENDCOLOR}"
fi


