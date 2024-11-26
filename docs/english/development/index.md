# Development Guide
## Requirements

- Ruby 3.3.6
- Rails 8
- SQLite3

## Setup
### Install Ruby and Docker

Install Ruby 3.3.6 and Docker that need to deploy.
Recommended to use `rbenv` and other version management tools to install Ruby.

### Clone ActivityPub Relay code

```console
git clone https://github.com/S-H-GAMELINKS/activity-pub-relay.git
```

Finished code clone, move to `activity-pub-relay` directory.


### ActivityPub Relay Setup

Run `bundle install`.

```console
bundle install
```

Then run `bin/rails db:create db:setup`.

```console
bin/rails db:create db:setup db:seed
```

Finally, `bin/rails s` to up server.

```console
bin/rails s
```

You can access to `localhost:3000`, setup is done.

### Run test

Use `bin/rspec`.

```console
bin/rspec
```

### Run Rubocop

Use `bin/rubocop`

```console
bin/rubocop
```

