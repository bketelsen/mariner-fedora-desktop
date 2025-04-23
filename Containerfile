FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora-ostree-desktops/silverblue:40

RUN echo -e "[edge-yum]\nname=edge-yum\nbaseurl=https://packages.microsoft.com/yumrepos/edge/\ngpgcheck=0\nenabled=1" | tee /etc/yum.repos.d/microsoft-edge.repo > /dev/null && \
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=0" | tee /etc/yum.repos.d/vscode.repo > /dev/null && \
    rpm-ostree install microsoft-edge-stable code dnf dnf5-plugins

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/boot \
    /ctx/build.sh && \
    ostree container commit
