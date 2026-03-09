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
    && echo "root:${ROOT_PASSWORD}" | chpasswd \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw @google/gemini-cli

RUN curl -fsSL https://claude.ai/install.sh | bash

USER node
WORKDIR /home/node

ENV HOME=/home/node
ENV SHELL=/bin/zsh

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting)/' ${HOME}/.zshrc \
    && echo "export PATH=\$PATH:\$(npm config get prefix)/bin" >> ${HOME}/.zshrc \
    && echo 'PROMPT="%{$fg_bold[blue]%}[docker]%{$reset_color%} $PROMPT"' >> ${HOME}/.zshrc

EXPOSE 8080

ENTRYPOINT ["openclaw", "gateway", "run"]
