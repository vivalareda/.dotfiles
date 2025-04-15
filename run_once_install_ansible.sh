#!/bin/sh

install_on_mac() {
  brew install ansible
}

install_on_arch() {
  sudo pacman -S ansible
}

install_on_ubuntu() {
  sudo apt-get update
  sudo apt-get install -y ansible
}

DIRECTORY=$(which ansible)

if [ -z "$DIRECTORY" ]; then
  OS="$(uname -s)"
  case "$OS" in
    Linux*)
      if [ -f /etc/arch-release ]; then
          install_on_arch
      elif [ -f /etc/lsb-release ] && grep -qi "ubuntu" /etc/lsb-release; then
        install_on_ubuntu
      else
        echo "Unsupported Linux distro"
        exit 1
      fi
        ;;
      Darwin*)
        install_on_mac
        ;;
      *)
        echo "Unsupported Linux distro"
        exit 1
        ;;
    esac
else
  echo "ansible already installed, starting setup"
fi

ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass -e "os_type=$OS" -v

echo "Ansible installation complete."
