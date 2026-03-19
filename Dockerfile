ARG BASE_TEMPLATE=shell
FROM docker/sandbox-templates:${BASE_TEMPLATE}

ARG TARGETARCH

USER root

# Install essential tools
RUN apt-get update && \
    apt-get install -yy --no-install-recommends \
        zsh \
        vim \
        bat \
        autojump \
        python-is-python3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install VS Code CLI for tunnel support
RUN if [ "$TARGETARCH" = "arm64" ]; then \
      VSCODE_ARCH="cli-alpine-arm64"; \
    else \
      VSCODE_ARCH="cli-alpine-x64"; \
    fi && \
    curl -fsSL "https://code.visualstudio.com/sha/download?build=stable&os=${VSCODE_ARCH}" \
    -o /tmp/vscode-cli.tar.gz && \
    tar -xzf /tmp/vscode-cli.tar.gz -C /usr/local/bin && \
    rm /tmp/vscode-cli.tar.gz

# Install git-delta
ARG DELTA_VERSION=0.18.2
RUN curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${TARGETARCH}.deb" \
    -o /tmp/git-delta.deb && \
    dpkg -i /tmp/git-delta.deb && \
    rm /tmp/git-delta.deb

# Change default shell for agent
RUN chsh -s /usr/bin/zsh agent
ENV SHELL=/usr/bin/zsh

# Set timezone
ENV TZ=Europe/Amsterdam

# Install oh-my-zsh
USER agent
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended

# Apply zsh customizations (after oh-my-zsh creates .zshrc)
COPY --chown=agent:agent zsh-custom.sh /tmp/zsh-custom.sh
RUN bash /tmp/zsh-custom.sh && rm /tmp/zsh-custom.sh

CMD ["zsh"]