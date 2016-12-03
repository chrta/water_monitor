defmodule SimpleDnsServer.Worker do
@moduledoc """
The DNS server

It replies to all queries with a fixed IP.
"""

  use GenServer

  @behaviour DNS.Server

  @doc """
  Starts the dns server worker with the given `name`.
  """
  def start_link(ip, opts \\ []) do
    GenServer.start_link(__MODULE__, ip, opts)
  end


  def handle(record, {_ip, _}) do
    GenServer.call __MODULE__, {:resolve, record}
  end

  ## Server Callbacks

  def init(ip) do
    {:ok, %{ip: ip}}
  end

  def handle_call({:resolve, record}, _from, state) do
    query = hd(record.qdlist)

    resource = %DNS.Resource{
      domain: query.domain,
      class: query.class,
      type: query.type,
      ttl: 0,
      data: state.ip
    }

    {:reply, %{record | anlist: [resource]}, state}
  end
end
