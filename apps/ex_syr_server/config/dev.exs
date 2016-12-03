use Mix.Config

config :ex_syr_server,
  http: [port: 4000]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
