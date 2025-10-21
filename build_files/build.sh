#!/bin/bash

set -ouex pipefail

if ! grep -q "exclude=ibus" /etc/dnf/dnf.conf; then
    echo "exclude=ibus ibus-* ibus-libs ibus-gtk2 ibus-gtk3 ibus-gtk4" >> /etc/dnf/dnf.conf
fi


dnf5 remove -y @kde-desktop-environment \
               xwaylandvideobridge \
               sunshine \
               kdeconnect \
               kdebugsettings \
               krfb \
               nheko \
               rhythmbox \
               okular \
               kde-desktop-sharing \
               kwallet* \
               plasma-* \
               kscreen* \
               kio-* \
               kaccounts* \
               kservice* \
               dolphin \
               ark

dnf5 clean all && rm -rf /var/cache/dnf/*


dnf5 install -y @cosmic-desktop-environment \
                neovim \
                ncdu \
                NetworkManager-tui \
				gamemode

dnf5 clean all && rm -rf /var/cache/dnf/*


dnf5 copr enable -y che/zed
dnf5 copr enable -y ilyaz/LACT

dnf5 install -y zed \
                lact

dnf5 clean all && rm -rf /var/cache/dnf/*

mkdir -p /nix && \
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix -o /nix/determinate-nix-installer.sh && \
  chmod a+rx /nix/determinate-nix-installer.sh

systemctl disable display-manager
systemctl disable gdm || true
systemctl disable sddm || true
systemctl enable cosmic-greeter
systemctl enable lactd
systemctl enable podman.socket
