ARG RUBY_VERSION=3.3.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y curl git ruby autoconf gcc make zlib1g-dev libffi-dev libreadline-dev libgdbm-dev libssl-dev libyaml-dev libjemalloc2 libvips sqlite3

RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --output google-chrome-stable_current_amd64.deb && apt install -y ./google-chrome-stable_current_amd64.deb
