use Mix.Config

config :ex_syr_server,
  http: [port: {:system, "PORT"}]

# Do not print debug messages in production
config :logger, level: :info
