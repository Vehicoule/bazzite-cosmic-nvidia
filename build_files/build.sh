#!/bin/bash

set -ouex pipefail

dnf5 group info kde-desktop | \
    sed -n '/^Mandatory packages\s*:/,/^\(Default\|Optional\) packages\s*:/ {
        /^\(Default\|Optional\) packages\s*:/q  # Quit if we hit Default/Optional header
        s/^.*:[[:space:]]*//p
    }' | \
    xargs dnf5 remove -y

#dnf5 remove plasma-desktop \
#               xwaylandvideobridge \
#               sunshine \
#               kdeconnect \
#               kdebugsettings \
#               krfb \
#               nheko \
#               rhythmbox \
#               okular \
#               kwallet* \
#               plasma-* \
#               kscreen* \
#               kio-* \
#               kaccounts* \
#               kservice* \
#               dolphin \
#               ark

dnf5 clean all && \
rm -rf /var/cache/dnf/*


dnf5 install -y cosmic-desktop \
				cosmic-desktop-apps \
				@cosmic-desktop-environment \
                neovim \
                ncdu \
                NetworkManager-tui \
				gamemode

dnf5 clean all && \
rm -rf /var/cache/dnf/*


dnf5 copr enable -y che/zed && \
  dnf5 install -y zed && \
  dnf5 copr disable che/zed

dnf5 copr enable -y ilyaz/LACT && \
  dnf5 install -y lact && \
  dnf5 copr disable ilyaz/LACT

dnf5 clean all && \
rm -rf /var/cache/dnf/*

mkdir -p /nix && \
  setenforce Permissive && \
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install && \
#  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix -o /nix/determinate-nix-installer.sh && \
#  chmod a+rx /nix/determinate-nix-installer.sh && \
  setenforce Enforcing

systemctl disable display-manager
systemctl disable gdm || true
systemctl disable sddm || true
systemctl enable cosmic-greeter
systemctl enable lactd
systemctl enable podman.socket
