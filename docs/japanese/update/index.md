# アップデート手順

## Rubyのバージョンアップ（必要時）

リリースノートを確認し、必要に応じて手元のPCのRubyについてバージョンアップを行なってください。


## 更新内容の確認とソース変更

手元のPCにて`activity-pub-relay`ディレクトリへ移動し、更新されたソースを取り込みます。

```console
git fetch --tags
git checkout <new tag>
```

## パッケージアップデート

`bundle install` を実行します。

```console
bundle install
```

## サーバへデプロイ

`kamal deploy` を実行してください。

```console
kamal deploy
```