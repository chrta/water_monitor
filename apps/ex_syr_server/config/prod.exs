use Mix.Config

config :ex_syr_server,
  http: [port: 80]

# Do not print debug messages in production
config :logger, level: :info

# tell logger to load a LoggerFileBackend processes named data_log
config :logger,
  backends: [{LoggerFileBackend, :data_log}]

# configuration for the {LoggerFileBackend, :data_log} backend
config :logger, :data_log,
  path: "/var/log/water_monitor/data.log",
  level: :info,
  metadata_filter: [data: true]
