# 開発ガイド
## 必要なソフトウェアなど

- Ruby 3.4.1
- Rails 8
- SQLite3

## セットアップ
### Ruby と Docker をインストール

Ruby 3.4.1 とDocker をインストールしてください。
Rubyについてはrbenvなどのバージョン管理ツールを使ってインストールするのがオススメです。

### ソースコードのclone

```console
git clone https://github.com/S-H-GAMELINKS/activity-pub-relay.git
```

clone 後、`activity-pub-relay`ディレクトリへ移動します。


### ActivityPub Relayのセットアップ

`bundle install` を実行します。

```console
bundle install
```

その後、`bin/rails db:create db:setup`を実行します。

```console
bin/rails db:create db:setup db:seed
```

あとは`bin/dev`でサーバを起動します。

```console
bin/dev
```

`localhost:3000`にアクセスできればセットアップは完了です。

### テストの実行

テストは`bin/rspec` で実行します。

```console
bin/rspec
```

### Rubocopの実行

Rubocopは`bin/rubocop` で実行します。

```console
bin/rubocop
```



