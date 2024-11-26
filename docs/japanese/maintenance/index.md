## メンテナンス手順
### ログの監視

```console
kamal app logs -f
```

### Railsコンソールを開く

```console
kamal console

# または

kamal app exec bin/rails c -i
```

### サーバのコンソールを開く

```console
kamal app exec bash -i
```

### Kamalの設定値の確認

```console
kamal config
# IPアドレスやSSHのポート番号などの設定情報が表示されます 
```

### デプロイ

```console
kamal deploy
```

