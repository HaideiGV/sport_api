FROM elixir:1.7.3

RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

WORKDIR /sport_api

EXPOSE 4000
