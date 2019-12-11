FROM node:12.13-slim

WORKDIR /app

ENV TZ Asia/Shanghai

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y openssh-client cron --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY package.json .

RUN npm install --production

COPY . .

RUN chmod 600 -R .ssh \
    && mv .ssh $HOME/

RUN mv crontab /etc/cron.d/crontab

RUN chmod 0644 /etc/cron.d/crontab

RUN crontab /etc/cron.d/crontab

CMD ./update.sh && cron -f