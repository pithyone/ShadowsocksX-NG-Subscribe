# ShadowsocksX-NG-Subscribe

如果你正在为 [ShadowsocksX-NG](https://github.com/shadowsocks/ShadowsocksX-NG) 没有订阅功能而苦恼，碰巧电脑上又装有 [Docker](https://www.docker.com)，那么本项目就很适合你。

## 历程

- 先是 google 了一番，发现没有类似的东西解决这个需求，遂决定自己动手
- 在 ShadowsocksX-NG 项目 Issues 中发现了宝藏，就是这个 :point_right: [#168](https://github.com/shadowsocks/ShadowsocksX-NG/issues/168#issuecomment-269783544)，提供了一种批量修改配置的方式
- 有了批量修改还不够，订阅会不定期更新，所以还需要定时刷新，考虑到直接本机安装定时服务配置复杂且不容易迁移，所以决定用 Docker 容器运行定时任务
- 因为修改配置后需要重启 ShadowsocksX-NG 才能生效，所以需要在 Docker 容器内执行主机命令，google 了一番发现由容器 ssh 主机的方式最适合，也是因为这个原因本机需要开启远程登录
- 选择 JavaScript 解析订阅内容，搞定

## 原理

1. 请求订阅地址
2. 解析订阅内容
3. 生成 ShadowsocksX-NG 配置文件
4. ssh 主机重启 ShadowsocksX-NG
5. 定时执行上述操作

## 依赖

1. 最新版 [ShadowsocksX-NG](https://github.com/shadowsocks/ShadowsocksX-NG)
2. 最新版 [Docker](https://www.docker.com)
3. 确保 `~/.ssh` 目录存在，可以通过 `mkdir -p ~/.ssh` 命令进行创建
4. 本机开启远程登录，参考 :point_right: [允许远程电脑访问您的 Mac](https://support.apple.com/zh-cn/guide/mac-help/mchlp1066/mac)

## 安装

使用下面的命令下载 ShadowsocksX-NG-Subscribe 镜像

```bash
$ docker pull pithyone/shadowsocksx-ng-subscribe
```

使用下面的命令运行 ShadowsocksX-NG-Subscribe

```bash
$ docker run -d \
-e HOST_USER=$USER \
-e URL="***" \
-v $HOME/.ssh:/root/.ssh/host \
--name shadowsocksx-ng-subscribe \
pithyone/shadowsocksx-ng-subscribe
```

- 将 `***` 替换成你自己的订阅地址
- :warning::warning::warning: 运行后订阅地址的节点将覆盖原有节点，请注意备份 :warning::warning::warning:

如果订阅更新了但是 ShadowsocksX-NG-Subscribe 没有及时更新，请运行下面的命令强制更新

```bash
$ docker run --rm \
-e HOST_USER=$USER \
-e URL="***" \
-v $HOME/.ssh:/root/.ssh/host \
pithyone/shadowsocksx-ng-subscribe \
./update.sh
```

- 将 `***` 替换成你自己的订阅地址
- :warning::warning::warning: 运行后订阅地址的节点将覆盖原有节点，请注意备份 :warning::warning::warning:

使用下面的命令关闭 ShadowsocksX-NG-Subscribe

```bash
$ docker stop shadowsocksx-ng-subscribe
```

## 更新

删除旧容器

```bash
$ docker stop shadowsocksx-ng-subscribe
$ docker rm shadowsocksx-ng-subscribe
```

然后重复安装步骤

## 常见问题

Q: 为什么要开启远程登录？

A: 在 Docker 容器内需要通过 ssh 的方式运行重启 ShadowsocksX-NG 的命令，本项目不上传任何数据，如果因为其他软件导致的安全性问题，本项目概不负责

Q: 订阅地址如何获取？

A: 本项目只提供在订阅更新后自动填充节点的功能，不提供任何的订阅地址
