# Options
## Use ActivtyPub Relay as a limited Hashtag Relay
After you deploy this option, ActivtyPub Relay will rebroadcast posts that include allowed hashtags only.

### How to deploy
Move to the cloned directory of your computer, and set ALLOWED_HASHTAGS environment variable as below.

```
ALLOWED_HASHTAGS=#activitypub,#activitypub_relay
```

- `#` is needed for each tag
- Separate each tag with commas
- Do **not** make space after commas

Then run `kamal deploy` to deploy the changes to your server.

```console
kamal deploy
```