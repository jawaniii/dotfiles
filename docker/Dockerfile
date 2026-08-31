# Portable demo of the terminal dashboard (tmux + btop + fastfetch, Catppuccin Mocha).
# Does NOT reproduce Ghostty itself or the macOS-level setup — those are native GUI/host
# things a container can't hold. This is the inside-the-terminal layer only.
FROM debian:bookworm-slim

# btop refuses to start without a UTF-8 locale ("No UTF-8 locale detected!").
# C.UTF-8 ships with glibc by default — no locale-gen / extra package needed.
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
      curl ca-certificates tmux zsh \
    && rm -rf /var/lib/apt/lists/*

# Debian bookworm's apt package is btop 1.2.13, which crashes on startup in this
# environment ("Cpu:: -> key not found" even with check_temp/show_gpu_info off —
# a version-specific bug). Install the current upstream static release instead.
RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "$dpkgArch" in \
      amd64) btopArch=x86_64-unknown-linux-musl ;; \
      arm64) btopArch=aarch64-unknown-linux-musl ;; \
      *) echo "unsupported arch: $dpkgArch" >&2; exit 1 ;; \
    esac; \
    curl -sL -o /tmp/btop.tar.gz "https://github.com/aristocratos/btop/releases/latest/download/btop-${btopArch}.tar.gz"; \
    tar -xzf /tmp/btop.tar.gz -C /tmp; \
    install -m 0755 /tmp/btop/bin/btop /usr/local/bin/btop; \
    rm -rf /tmp/btop.tar.gz /tmp/btop

# fastfetch isn't in Debian bookworm's repos — install the official .deb release
RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "$dpkgArch" in \
      amd64) ffArch=amd64 ;; \
      arm64) ffArch=aarch64 ;; \
      *) echo "unsupported arch: $dpkgArch" >&2; exit 1 ;; \
    esac; \
    curl -sL -o /tmp/fastfetch.deb "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${ffArch}.deb"; \
    apt-get update && apt-get install -y /tmp/fastfetch.deb; \
    rm -rf /tmp/fastfetch.deb /var/lib/apt/lists/*

RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

COPY tmux/tmux.conf /root/.tmux.conf
COPY starship/starship.toml /root/.config/starship.toml
COPY fastfetch/umersprofile-simple.jsonc /root/.config/fastfetch/umersprofile-simple.jsonc
COPY btop/btop.conf /root/.config/btop/btop.conf
COPY btop/themes/catppuccin_mocha.theme /root/.config/btop/themes/catppuccin_mocha.theme
# Containers have no real hardware temp sensors to read — check_temp=true crashes btop
# ("Cpu:: -> key not found"). Patched only in this image layer, not in the source
# dotfiles/btop/btop.conf, since check_temp works correctly on the real Mac.
RUN sed -i 's/^check_temp = true/check_temp = false/' /root/.config/btop/btop.conf
# Same crash, second known cause (btop issue #899): show_gpu_info="Auto" probes for a
# GPU that doesn't exist in the container and throws the identical "Cpu:: -> key not
# found" exception. Also patched only in this image layer — GPU monitoring is real and
# wanted on the actual M4 Max.
RUN sed -i 's/^show_gpu_info = "Auto"/show_gpu_info = "Off"/' /root/.config/btop/btop.conf
COPY bin/dashboard /usr/local/bin/dashboard
COPY bin/tmux-toggle-btop /usr/local/bin/tmux-toggle-btop
RUN chmod +x /usr/local/bin/dashboard /usr/local/bin/tmux-toggle-btop

RUN echo 'eval "$(starship init zsh)"' >> /root/.zshrc

SHELL ["/bin/zsh", "-c"]
CMD ["/usr/local/bin/dashboard"]
