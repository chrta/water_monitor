defmodule SimpleDnsServer do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:simple_dns_server, :port)
    ip = get_interface_ip Application.get_env(:simple_dns_server, :interface)
    
    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: SimpleDnsServer.Worker.start_link(arg1, arg2, arg3)
      worker(SimpleDnsServer.Worker, [ip, [name: SimpleDnsServer.Worker]]),
      worker(Task, [DNS.Server, :accept, [port, SimpleDnsServer.Worker]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleDnsServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_interface_ip(if_name) do
    {:ok, ifs} = :inet.getifaddrs() 
    [{^if_name, props}] = Enum.filter ifs, fn {name, _props} -> name == if_name end
    addresses = Keyword.get_values props, :addr
    [ipv4_address] = Enum.filter addresses, fn addr -> tuple_size(addr) == 4 end
    ipv4_address
  end

end
