defmodule SimpleDnsServerTest do
  use ExUnit.Case
  doctest SimpleDnsServer

  @tag timeout: 1000
  test "#resolve" do
    ip = {127, 0, 0, 1}
    port = Application.get_env(:simple_dns_server, :port)
    
    actual = DNS.resolve("example.com", {"localhost", port})
    assert ip == actual
  end
  
end
