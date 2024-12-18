
## デプロイ手順
### Ruby と Docker をインストール

Ruby 3.3.6 とDocker をインストールしてください。

### ActivityPub Relay のコードをclone

```console
git clone https://github.com/S-H-GAMELINKS/activity-pub-relay.git
```

clone 後、`activity-pub-relay`ディレクトリへ移動して、`bundle install` を実行します。

```console
bundle install
```

Kamalで利用するcredentialを作成し、`secret_key_base` の値をコピーします。
`secret_key_base` の値はあとで ActivityPub Relay のデプロイ時に環境変数で利用します。

```
EDITOR=<Your Editor> bin/rails credentials:edit
```

### Actorキーを生成

リレーで必要なActorキーを生成します。

```console
bin/rails relay:keygen 
```

### SSHキーの生成

ActivityPub Relay はサーバへのデプロイにSSHキーが必要です。
そのため、SSHキーをローカル環境で生成してください。
SSHキーを生成後、公開鍵をメモしてください。
公開鍵はサーバの設定時に利用します。

### サーバのセットアップ

ActivityPub Relay は Kamal を使ってサーバへデプロイします。
そのために必要なソフトウェアのインストールなどを行います。

```console
sudo apt update
sudo apt upgrade -y
sudo apt install -y docker.io curl git
sudo usermod -a -G docker <Server Username>
```

また、公開鍵をサーバに設定します。

### レジストリのトークン

Kamal はレジストリを経由してDockerイメージをサーバへデプロイします。
レジストリの credentials が必要になります。

もし Docker Hub を使っている場合は、Docker Hub APIトークンを取得してください。
また権限は `Read / Write` で取得してください。
またアカウント名もメモしてください。

### SSHキーの読み込み

Kamal はサーバへのデプロイ時にSSHキーを使用します。
そのため、SSHキーの秘密鍵を読み込んでおきます。

```console
ssh-add <SSH Private Key Path>
```

### Kamal の設定変更

デプロイに必要な設定を変更します。


`.env.sample` をもとに `.env` を作成します。

```console
cp .env.sample .env
```

サーバへのデプロイに必要な情報をセットしていきます。

```
SERVER_IP=<サーバの IP>
SERVER_USERNAME=<サーバのユーザー名>
SERVER_SSH_PORT=<サーバのSSH接続のポート>
LOCAL_DOMAIN=<サーバのドメイン>
KAMAL_REGISTRY_USERNAME=<レジストリのアカウント名>
KAMAL_REGISTRY_PASSWORD=<レジストリのAPIトークン>
SECRET_KEY_BASE=<`secret_key_base`の値>
TERM_OF_SERVICE_LINK=<利用規約へのリンク>
SOURCE_CODE_LINK=<フォークしている場合はフォークへのリンク>
ADMIN_LINKS=<Fediverseでのアカウントへのリンク>
```

### サーバへデプロイ

`kamal setup` を実行します。

```console
kamal setup
```

もしデプロイ後に何か変更をコミットし、デプロイする場合は `kamal deploy` を実行してください。

```console
kamal deploy
```

### リレーサーバの初期設定

#### Kamalで本番環境のコンソールに入る

手元のPCの`activity-pub-relay`ディレクトリ内で`kamal console` を実行しましょう。

```console
kamal console
```

#### 管理ユーザーを追加

管理ユーザーのメールアドレスとパスワードを設定します。

```console
Account.create!(email: "<リレーサーバ管理者のメールアドレス>", password: "<リレーサーバ用のパスワード>")
Account.last.update(status: :verified)
```


#### ブラウザよりログイン

`https://<リレーサーバのドメイン>/login` にアクセスするとログイン画面が表示されます。先ほど設定したメールアドレスとパスワードでログインしてください。
Dashboardが表示されれば、初期設定は完了です。

もしOTP認証を有効にしたい場合は `https://<リレーサーバのドメイン>/otp-setup`にアクセスしてください。
表示されているQRコードを読み取り、パスワードとOTPを入力するとOTP認証が有効化されます。
