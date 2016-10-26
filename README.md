sc-coding-challenge
======

A simple app to search for the 25 most recent tweets by a given Twitter user.

Some highlights:

+ Uses Devise for user auth (didn't want to re-invent the wheel). Requires login to do anything.
 + Note that new user registrations are disabled. This is to prevent any random person from logging in. You'll need to manually create new accounts via console 
+ Skips using the `twitter` gem in favor of a custom `Twitter::Api` class.
 + The gem would have been faster to set up but that wouldn't have been as fun. I haven't used the Twitter API before (had to sign up for an actual account as well to get the keys). I wanted to poke around a bit so I figured I'd try to implement the interface myself.
+ Uses RSpec for tests (more human-readable plus I wanted more practice with it)
+ Uses Rails caching for results (5 minute expiration). I wanted to set up a recurring job to cleanup the cache so I configured one via Heroku's Scheduler guide but I didn't want to put my credit card info into my account so it doesn't actually do anything.

The views are admittedly very barebones but they get the job done. Definitely not my strong suit. Some interesting things:
+ @mentions and hash tags link to Twitter. This is done by the `twitter-text` gem. I tried doing this on my own but quickly realized my regex-fu was not up to snuff.
+ The timestamp on the tweet links to the tweet itself.

**Local setup**

First `bundle` to download + install dependencies

The required environment variables should be in `.env` (not checked into source; I can email the file to you)
The `foreman` gem will load environment variables from this file. Well, it actually just loads one environment variable (`TWITTER_ACCESS_TOKEN`) which I figured shouldn't be in source control.

To start the server:
```bash
foreman start
```

**Deploying to Heroku**

```bash
heroku create
git push heroku master
heroku run rake db:migrate
heroku open
```

**Running tests**

```bash
rspec spec
```
