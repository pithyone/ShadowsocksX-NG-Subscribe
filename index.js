const got = require('got');
const cheerio = require('cheerio');
const uuidv4 = require('uuid/v4');
const plist = require('plist');
const fs = require('fs');

(async () => {
    const response = await got('https://get.ishadowx.biz');

    const $ = cheerio.load(response.body);
    const nodes = [];
    const map = ['ServerHost', 'ServerPort', 'Password', 'Method'];

    $('.us,.sg').each(function (i, elem) {
        const node = {
            Id: uuidv4().toUpperCase(),
            Plugin: '',
            PluginOptions: '',
            Remark: '',
        };

        $(this).find('h4').slice(0, 4).each(function (i, elem) {
            const text = $(this).text().trim().split(':').pop();
            node[map[i]] = i === 1 ? Number(text) : text;
        });

        nodes.push(node);
    });

    if (nodes.length > 0) {
        const json =
            {
                'ActiveServerProfileId': nodes[0].Id,
                'LaunchAtLogin': true,
                'LocalSocks5.ListenAddress.Old': '127.0.0.1',
                'LocalSocks5.ListenPort.Old': 1086,
                'ServerProfiles': nodes,
                'ShadowsocksOn': true,
                'ShadowsocksRunningMode': 'auto'
            }
        ;

        fs.writeFileSync('com.qiuyuzhou.ShadowsocksX-NG.tmp.plist', plist.build(json));
    }
})();
