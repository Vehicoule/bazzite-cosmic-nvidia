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

dnf5 clean all && rm -rf /var/cache/dnf/*

dnf5 copr enable -y che/zed
dnf5 install -y zed
dnf5 clean all && rm -rf /var/cache/dnf/*

curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm
dnf5 clean all && rm -rf /var/cache/dnf/*

echo "/usr/bin/fish" | tee -a /etc/shells
sed -i 's|/bin/bash|/usr/bin/fish|' /etc/passwd

systemctl disable display-manager
systemctl enable cosmic-greeter.service -f
systemctl enable podman.socket
