## Deploy
### Install Ruby and Docker

Install Ruby 3.3.6 and Docker that need to deploy.

### Clone ActivityPub Relay code

```console
git clone https://github.com/S-H-GAMELINKS/activity-pub-relay.git
```

Move to clone directory, and run `bundle install`.

```console
bundle install
```

Create credentials for Kamal, and copy `secret_key_base` value.
`secret_key_base` value is used in ActivityPub Relay environment variable.

```
EDITOR=<Your Editor> bin/rails credentials:edit
```

### Generate Actor Key

ActivityPub Relay need Actor Key for Actor Relay.

```console
bin/rails relay:keygen 
```

### Generate SSH Key

ActivityPub Relay need SSH Key for deploy to server.
So, you need to generate SSH Key in local.
After generate SSH Key, noted Public Key value for add server.

### Setup Server

ActivityPub Relay use Kamal for deploy to server.
Need to setup like these commands.

```console
sudo apt update
sudo apt upgrade -y
sudo apt install -y docker.io curl git
sudo usermod -a -G docker <Server Username>
```

And, set to Public Key for SSH to server.

### Get Registry Token

Kamal use Registry for deploy Dockcer image to server.
You need to get Registry credentials.

If you use Docker Hub, you noted Docker Hub API token(that need Read / Write permmision) and account name.

### Load SSH key

Kamal use SSH Key for deploy to server.
So, you need load SSH Private Key.

```console
ssh-add <SSH Private Key Path>
```

### Setup Kamal settings

Setup to deploy configuration.

Create `.env` from `.env.sample`

```console
cp .env.sample .env
```

And set value for deploy server.

```
SERVER_IP=<Server IP>
SERVER_USERNAME=<Server Username>
SERVER_SSH_PORT=<Server SSH Port>
LOCAL_DOMAIN=<Server Domain>
KAMAL_REGISTRY_USERNAME=<Registry Username>
KAMAL_REGISTRY_PASSWORD=<Registry Password>
SECRET_KEY_BASE=<secret_key_base value>
TERM_OF_SERVICE_LINK=<Your Term of Service Link>
SOURCE_CODE_LINK=<Your Fork Code Link>
ADMIN_LINKS=<Your Fedives Account>
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


### Perform initial settings

#### Connect to console using Kamal

Run `kamal console` inside the cloned directory of your computer.

```console
kamal console
```

#### Add admin user to relay service

Configure your email address and password for the service.

```console
Account.create!(email: "<your mail address>", password: "<password for the service>")
Account.last.update(status: :verified)
```

#### Login from the Internet

You can now login from `https://<Server Domain>/login` by using the email address and the password you have set right now.
If you could login to the dashboard, initial settings are all done.

If you need OTP enabled, access to `https://<Server Domain>/otp-setup`.
Scan QR code, submit to password and  OTP number.
