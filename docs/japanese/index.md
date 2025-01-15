# ActivityPub Relay

Mastodon と Misskey(またはMisskeyフォーク) に対応したActivityPubリレーサーバです。
またPleromaとAkkomaにも対応しています。

## 参考実装

- [mayaeh/pub-relay-prototype](https://github.com/mayaeh/pub-relay-prototype)
- [mastoson/mastodon](https://github.com/mastodon/mastodon)
- [dtp-mstdn-jp/selective-relay](https://github.com/dtp-mstdn-jp/selective-relay)

ActivityPub Relay を実装するにあたってこれらのソフトウェアを参考にさせて頂きました。
この場を借りて感謝申し上げます。

## ライセンス

[AGPL-3.0 license](../../LICENSE)

## 必要なソフトウェアなど

- Ruby 3.4.1
- Rails 8.0.0
- SQLite3
- Docker

RedisやNginx、PostgreSQLなどのソフトウェアは必要ありません。

## リファレンス
- [開発ガイド](./development/index.md)
- [デプロイ手順](./deploy/index.md)
- [アップデート手順](./update/index.md)
- [メンテナンス手順](./maintenance/index.md)
- [オプション項目](./option/index.md)
