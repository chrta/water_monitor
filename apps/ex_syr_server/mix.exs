defmodule ExSyrServer.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_syr_server,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:cowboy, :plug, :logger, :observer_cli],
     mod: {ExSyrServer, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:sweet_xml, "~> 0.6.3"},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.14", only: :dev},
      {:observer_cli, "~> 1.1"},
      {:logger_file_backend, "~> 0.0.9"}
    ]
  end
end
