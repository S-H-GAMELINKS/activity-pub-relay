# ActivityPub Relay

Mastodon and Misskey(or other Misskey fork) supported ActivityPub Relay.

## References

- [mayaeh/pub-relay-prototype](https://github.com/mayaeh/pub-relay-prototype)
- [mastoson/mastodon](https://github.com/mastodon/mastodon)
- [dtp-mstdn-jp/selective-relay](https://github.com/dtp-mstdn-jp/selective-relay)

I refereced these software codes when implementing ActivityPub Relay.
Thank you for these software implemented and maintained.

## LICENSE

[AGPL-3.0 license](../../LICENSE)

## Requirements

- Ruby 3.3.6
- Rails 8.0.0
- SQLite3
- Docker

You do not need Redis, Nginx, nor PostgreSQL to deploy this Relay.

## References

- [Development Guide](./development/index.md)
- [Deploy](./deploy/index.md)
- [Update](./update/index.md)
- [Maintainance](./maintenance/index.md)
- [Options](./option/index.md)
