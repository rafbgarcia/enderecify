FROM elixir:slim
WORKDIR /app
RUN apt-get update && apt-get install -y git
RUN mix local.rebar --force && mix local.hex --force
ENV MIX_ENV=prod REPLACE_OS_VARS=true TERM=xterm
CMD ["mix", "release", "--env=prod", "--executable", "--verbose"]
