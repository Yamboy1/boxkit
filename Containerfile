FROM quay.io/toolbx-images/archlinux-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="yamboyd1@gmail.com"
      
RUN useradd --shell=/bin/false build && usermod -L build
RUN mkdir -p /home/build
RUN chown build:build /home/build
RUN echo "build ALL=(ALL) NOPASSWD: /usr/bin/pacman" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: /usr/bin/pacman" >> /etc/sudoers

COPY extra-packages /
USER build

RUN cd ~ && \
    pwd && \
    sudo pacman -Syu --noconfirm && \
    # Install paru so we can use aur stuff
    git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg -si --noconfirm && \
    grep -v '^#' /extra-packages | xargs paru -S --noconfirm && \
    rm -rfv ~/.cache/paru
   
USER root
RUN rm /extra-packages
RUN userdel -r build
# RUN head -n -2 /etc/sudoers > /etc/sudoers
# This causes symlink errors currently

# RUN   ln -fs /bin/sh /usr/bin/sh && \
#       ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
#       ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
#       ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
#       ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
#       ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
     
