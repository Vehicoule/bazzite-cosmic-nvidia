#!/bin/bash

set -ouex pipefail

if ! grep -q "exclude=ibus" /etc/dnf/dnf.conf; then
    echo "exclude=ibus ibus-* ibus-libs ibus-gtk2 ibus-gtk3 ibus-gtk4" >> /etc/dnf/dnf.conf
fi

dnf5 update -y

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
dnf5 copr enable -y ilyaz/LACT

dnf5 install -y zed \
                lact

dnf5 clean all && rm -rf /var/cache/dnf/*

mkdir -p /nix && \
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix -o /nix/determinate-nix-installer.sh && \
	chmod a+rx /nix/determinate-nix-installer.sh

cat > /etc/profile.d/gaming.sh << 'EOF'
# Enable Steam native runtime by default (better compatibility)
export STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0

# Enable MangoHud for all Vulkan applications (if installed)
# export MANGOHUD=1

# Enable gamemode for supported applications
export LD_PRELOAD="libgamemode.so.0:$LD_PRELOAD"

# Optimize for AMD GPUs (uncomment if using AMD)
# export RADV_PERFTEST=aco,llvm
# export AMD_VULKAN_ICD=RADV

# Optimize for NVIDIA GPUs (uncomment if using NVIDIA)
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_SHADER_DISK_CACHE=1
EOF

dnf5 clean all && rm -rf /var/cache/dnf/*

echo "/usr/bin/fish" | tee -a /etc/shells
sed -i 's|/bin/bash|/usr/bin/fish|' /etc/passwd

systemctl disable display-manager
systemctl enable cosmic-greeter.service -f
systemctl enable lactd
systemctl enable podman.socket
