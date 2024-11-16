# ActivityPub Relay

Mastodon and Misskey(or other Misskey fork) supported ActivityPub Relay.

## References

[mayaeh/pub-relay-prototype](https://github.com/mayaeh/pub-relay-prototype)
[mastoson/mastodon](https://github.com/mastodon/mastodon)

I refereced these software codes when implementing ActivityPub Relay.
Thank you for these software implemented and maintained.

## LICENSE

[AGPL-3.0 license](./LICENSE)

## Requirements

- Ruby 3.3.6
- Rails 8.0.0
- SQLite3

## Deploy
### Generate SSH Key

ActivityPub Relay need SSH Key for deploy to server.
So, you need to generate SSH Key.
After generate SSH Key, noted Public Key value.

### Setup Server

ActivityPub Relay use Kamal for deploy to server.
Need to setup like these commands.

```console
sudo apt update
sudo apt upgrade -y
sudo apt install -y docker.io curl git
sudo usermod -a -G docker app
```

And, set to Public Key for SSH to server.

### Get Registry Token

Kamal use Registry for deploy Dockcer image to server.
You need to get Registry credentials.

If you use Docker Hub, you noted Docker Hub API token(that need Read / Write permmision) and account name.

### Setup Kamal settings

Setup to deploy configuration.

```yml
image: <Registry Account Nmae>/activity_pub_relay

servers:
  web:
    - <Server IP Address>

proxy:
  ssl: true
  app_port: 3000
  host: <Server Domain>

registry:
  user: <Registry Account Name>
  password: <Registry API Token or Registry Account Password>

end:
  secret:
    - RAILS_MASTER_KEY
  clear:
    SOLID_QUEUE_IN_PUMA: true
    LOCAL_DOMAIN: <Server Domain>

ssh:
  user: <Server User Name>
  port: <Server SSH port>

```


### Deploy to server

Run `kamal setup`.

```console
kamal setup
```

If you need to deploy after some change commited.

Run `kamal deploy`.

```console
kamal deploy
```
