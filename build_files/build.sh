#!/bin/bash

set -ouex pipefail

dnf5 remove -y @kde-desktop-environment \
               xwaylandvideobridge \
               sunshine \
               kdeconnect \
               kdebugsettings \
               haruna \
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
                fish \
                util-linux-user

dnf5 copr enable -y che/zed
dnf5 install -y zed

echo "/usr/bin/fish" | tee -a /etc/shells
sed -i 's|/bin/bash|/usr/bin/fish|' /etc/passwd
chsh -s /usr/bin/fish

dnf5 clean all && rm -rf /var/cache/dnf/*

systemctl disable display-manager
systemctl enable cosmic-greeter.service -f
systemctl enable podman.socket
