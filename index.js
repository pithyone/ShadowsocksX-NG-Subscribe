const got = require('got');
const base64 = require('base-64');
const SHADOWSOCKS_URI = require('outline-shadowsocksconfig').SHADOWSOCKS_URI;
const uuidv4 = require('uuid/v4');
const plist = require('plist');
const fs = require('fs');

(async () => {
    const response = await got(process.env.URL);

    const nodes = [];

    base64.decode(response.body).split('\n').forEach(item => {
        try {
            const config = SHADOWSOCKS_URI.parse(item);

            const plugin = config.extra.plugin;

            nodes.push({
                Id: uuidv4().toUpperCase(),
                Method: config.method.data,
                Password: config.password.data,
                Plugin: plugin ? plugin.split(';', 1).pop() : '',
                PluginOptions: plugin ? plugin.split(';').slice(1).join(';') : '',
                Remark: config.tag.data,
                ServerHost: config.host.data,
                ServerPort: config.port.data,
            });
        } catch (e) {
            //
        }
    });

    if (nodes.length <= 0) {
        throw new Error('subscribe url return none');
    }

    const json = {
        'ActiveServerProfileId': nodes[0].Id,
        'LaunchAtLogin': true,
        'LocalSocks5.ListenAddress.Old': '127.0.0.1',
        'LocalSocks5.ListenPort.Old': 1086,
        'ServerProfiles': nodes,
        'ShadowsocksOn': true,
        'ShadowsocksRunningMode': 'auto'
    };

    fs.writeFileSync('com.qiuyuzhou.ShadowsocksX-NG.tmp.plist', plist.build(json));
})();
