defmodule ExSyrServer do
  @moduledoc"""
  Server that receivs data via http from Syr device

  """

  use Application

  alias ExSyrServer.Router
  alias Plug.Adapters.Cowboy

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    http_settings = Application.get_env :ex_syr_server, :http
    # Define workers and child supervisors to be supervised
    children = [
      Cowboy.child_spec(:http, Router, [], http_settings),
      worker(GenEvent, [[name: :syr_event_manager]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExSyrServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
