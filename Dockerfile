FROM node:12.13-slim

WORKDIR /app

ENV TZ Asia/Shanghai

ARG USE_MIRROR=0

RUN if [ "$USE_MIRROR" = 1 ]; then \
  echo 'use mirror' \
  && sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
  && sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list \
  && npm config set registry https://registry.npm.taobao.org; \
  fi;

RUN apt-get update \
    && apt-get install -y openssh-client cron git --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY package.json .

RUN npm install --production

COPY . .

RUN mkdir -p /root/.ssh/host

RUN mv crontab /etc/cron.d/crontab

RUN chmod 0644 /etc/cron.d/crontab

RUN crontab /etc/cron.d/crontab

CMD yes n | ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' ; cd /root/.ssh \
    && touch host/authorized_keys \
    && grep -f id_rsa.pub host/authorized_keys || cat id_rsa.pub >> host/authorized_keys \
    && printenv | grep -v "no_proxy" >> /etc/environment \
    && cd /app \
    && ./update.sh \
    && cron -f
