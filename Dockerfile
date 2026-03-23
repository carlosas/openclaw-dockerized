FROM node:22

ARG ROOT_PASSWORD=root

RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    make \
    g++ \
    zsh \
    jq \
    sudo \
    && echo "root:${ROOT_PASSWORD}" | chpasswd \
    && adduser node sudo \
    && echo "node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw @google/gemini-cli

RUN curl -fsSL https://claude.ai/install.sh | bash \
    && cp /root/.local/bin/claude /usr/local/bin/claude

USER node
WORKDIR /home/node

ENV HOME=/home/node
ENV SHELL=/bin/zsh
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting)/' ${HOME}/.zshrc \
    && echo 'export PATH=$PATH:/usr/local/bin' >> ${HOME}/.zshrc \
    && echo 'PROMPT="%{$fg_bold[blue]%}[${PROJECT_NAME:-my-project}]%{$reset_color%} $PROMPT"' >> ${HOME}/.zshrc

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["entrypoint.sh"]
CMD ["openclaw", "gateway", "run", "--allow-unconfigured"]
