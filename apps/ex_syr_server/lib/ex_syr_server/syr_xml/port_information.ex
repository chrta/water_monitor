
defmodule ExSyrServer.SyrXml.PortInformation do

  defstruct serial: "", pl: [], cs: ""
  
  def populate({:serial, %{serial: value}}, acc) do
    %{acc | serial: value}
  end
  def populate({:pl, [%{n: pl1, v: '1'}, %{n: pl2, v: '1'}]}, acc) do
    %{acc | pl: [pl1, pl2]}
  end
  def populate({:cs, %{cs: value}}, acc) do
    %{acc | cs: value}
  end
end
