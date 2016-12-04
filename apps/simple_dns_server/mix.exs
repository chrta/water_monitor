defmodule SimpleDnsServer.Mixfile do
  use Mix.Project

  def project do
    [app: :simple_dns_server,
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
    [applications: [:dns, :logger],
     mod: {SimpleDnsServer, []}]
  end

  defp deps do
    [
      {:dns, "~> 0.0.4"},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end
end
