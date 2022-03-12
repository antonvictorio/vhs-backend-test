FROM bitwalker/alpine-elixir:1.11.0 AS release_stage

COPY mix.exs .
COPY mix.lock .
RUN mix deps.get
RUN mix deps.compile

COPY config ./config
COPY lib ./lib
COPY test ./test

ENV MIX_ENV=prod
RUN mix release

FROM bitwalker/alpine-elixir:1.11.0 AS run_stage

COPY --from=release_stage $HOME/_build .
RUN chown -R default: ./prod
USER default
CMD ["./prod/rel/vhs/bin/vhs", "start"]