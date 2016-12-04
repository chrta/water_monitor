use Mix.Config

config :ex_syr_server,
  http: [port: 80]

# Do not print debug messages in production
config :logger, level: :info
