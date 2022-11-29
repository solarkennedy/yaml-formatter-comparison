FROM ubuntu:jammy
RUN apt update && apt -y install wget

#https://github.com/google/yamlfmt
RUN wget -q https://github.com/google/yamlfmt/releases/download/v0.6.0/yamlfmt_0.6.0_Linux_x86_64.tar.gz && \
  tar xf yamlfmt_0.6.0_Linux_x86_64.tar.gz && \
  rm yamlfmt_0.6.0_Linux_x86_64.tar.gz && \
  mv yamlfmt /usr/local/bin/google-yamlfmt

#https://github.com/jumanjihouse/pre-commit-hook-yamlfmt
RUN wget -q https://github.com/jumanjihouse/pre-commit-hook-yamlfmt/archive/refs/tags/0.2.2.tar.gz && \
  tar xf 0.2.2.tar.gz && rm 0.2.2.tar.gz && mv pre-commit-hook-yamlfmt-0.2.2 /root/ && \
  ln -s /root/pre-commit-hook-yamlfmt-0.2.2/pre_commit_hooks/yamlfmt /usr/local/bin/pre-commit-yamlfmt
 
#https://github.com/prettier/prettier
RUN apt -y install npm --no-install-recommends
WORKDIR /root
RUN npm install --save-dev --save-exact prettier@2.8.0
RUN ln -s /root/node_modules/prettier/bin-prettier.js /usr/local/bin/prettier

#https://pypi.org/project/yamlfmt/
RUN apt -y install python3-pip --no-install-recommends
RUN pip install yamlfmt==1.1.0
RUN ln -s /usr/local/bin/yamlfmt /usr/local/bin/python-yamlfmt
