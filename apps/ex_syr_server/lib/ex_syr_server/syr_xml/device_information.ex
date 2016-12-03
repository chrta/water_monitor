
defmodule ExSyrServer.SyrXml.DeviceInformation do
  @moduledoc"""
  Contains information about the syr device

  serial: The serial number
  mac: The ethernet MAC
  manufacturer: The device manufacturer
  den:
  sta:
  dat:
  device:
  """

  defstruct serial: "", mac: "", manufacturer: "", den: "", sta: "", dat: "", device: ""

  def populate(%{name: 'getSRN', value: value}, acc) do
    %{acc | serial: value}
  end
  def populate(%{name: 'getMAC', value: value}, acc) do
    %{acc | mac: value}
  end
  def populate(%{name: 'getMAN', value: value}, acc) do
    %{acc | manufacturer: value}
  end
  def populate(%{name: 'getDEN', value: value}, acc) do
    %{acc | den: value}
  end
  def populate(%{name: 'getSTA', value: value}, acc) do
    %{acc | sta: value}
  end
  def populate(%{name: 'getDAT', value: value}, acc) do
    %{acc | dat: value}
  end
  def populate(%{name: 'getCNA', value: value}, acc) do
    %{acc | device: value}
  end

end
