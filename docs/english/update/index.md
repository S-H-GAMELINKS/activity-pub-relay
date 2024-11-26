# Update

## Version up Ruby (if necessary)

Check the release notes, and version up Ruby of your computer, if necessary.


## Fetch the new tag and checkout

Move to the cloned directory of your computer, and update the code.

```console
git fetch --tags
git checkout <new tag>
```

## Update packages

Run `bundle install`.

```console
bundle install
```

## Deploy to server

Run `kamal deploy`.

```console
kamal deploy
```