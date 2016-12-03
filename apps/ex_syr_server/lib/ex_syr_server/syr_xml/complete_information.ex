
defmodule ExSyrServer.SyrXml.CompleteInformation do

  alias ExSyrServer.SyrXml.CompleteInformation.SubInfo

  @doc"""
  
  serial: The serial number of the device
  sta: always empty ""
  mac: The ethernet MAC address
  den: always "1"
  dn1: always "", may be "holiday mode" start
  dn2: always "", may be "holiday mode" end
  dev: always ""
  scr: always "0" ??? This information is doubled in the xml?
  ver: Firmware version
  fir: Firmware type
  lgo: always "1"
  prs: Water pressure [bar]
  pst: always "0"
  whu: always "0"
  owh: Outflowing water hardness [degree of German hardness]
  iwh: Inflowing water hardness [degree of German hardness]
  flo: always "0", may be water flow liters per minute
  res: rest capacity in liters (??) 92% = 975
  info1: Detailed information regarding storage 1
  info2: Detailed information regarding storage 2
  info3: Detailed information regarding storage 3
  lan: Ethernet enabled (?) always "1"
  cyn: always "0"
  cyt: time, always "00:00"
  rti: Regeneration time, always "00:00" (?)
  dat: Unix timestamp epoch
  """
  defstruct serial: "", sta: "", mac: "", den: "", dn1: "", dn2: "", dev: "", scr: "", ver: "", fir: "", lgo: "", prs: 0, pst: "", whu: "", owh: 0, iwh: 0, flo: "", res: 0, info1: %SubInfo{}, info2: %SubInfo{}, info3: %SubInfo{}, lan: "", cyn: "", cyt: "", rti: "", dat: ""
  
  def populate(%{name: 'getSRN', value: value}, acc) do
    %{acc | serial: value}
  end
  def populate(%{name: 'getSTA', value: value}, acc) do
    %{acc | sta: value}
  end
  def populate(%{name: 'getMAC', value: value}, acc) do
    %{acc | mac: value}
  end
  def populate(%{name: 'getDEN', value: value}, acc) do
    %{acc | den: value}
  end
  def populate(%{name: 'getDN1', value: value}, acc) do
    %{acc | dn1: value}
  end
  def populate(%{name: 'getDN2', value: value}, acc) do
    %{acc | dn2: value}
  end
  def populate(%{name: 'getDEV', value: value}, acc) do
    %{acc | dev: value}
  end
  def populate(%{name: 'getSCR', value: value}, acc) do
    %{acc | scr: value}
  end
  def populate(%{name: 'getVER', value: value}, acc) do
    %{acc | ver: value}
  end
  def populate(%{name: 'getFIR', value: value}, acc) do
    %{acc | fir: value}
  end
  def populate(%{name: 'getLGO', value: value}, acc) do
    %{acc | lgo: value}
  end
  def populate(%{name: 'getPRS', value: value}, acc) do
    number = String.to_integer(value)
    %{acc | prs: number / 10}
  end
  def populate(%{name: 'getPST', value: value}, acc) do
    %{acc | pst: value}
  end
  def populate(%{name: 'getWHU', value: value}, acc) do
    %{acc | whu: value}
  end
  def populate(%{name: 'getOWH', value: value}, acc) do
    number = String.to_integer(value)
    %{acc | owh: number}
  end
  def populate(%{name: 'getIWH', value: value}, acc) do
    number = String.to_integer(value)
    %{acc | iwh: number}
  end
  def populate(%{name: 'getFLO', value: value}, acc) do
    %{acc | flo: value}
  end
  def populate(%{name: 'getRES', value: value}, acc) do
    number = String.to_integer(value)
    %{acc | res: number}
  end
  def populate(%{name: 'getVS1', value: value}, acc) do
    put_in acc.info1.vs, value
  end
  def populate(%{name: 'getVS2', value: value}, acc) do
    put_in acc.info2.vs, value
  end
  def populate(%{name: 'getVS3', value: value}, acc) do
    put_in acc.info3.vs, value
  end
  def populate(%{name: 'getCS1', value: value}, acc) do
    put_in acc.info1.cs, value
  end
  def populate(%{name: 'getCS2', value: value}, acc) do
    put_in acc.info2.cs, value
  end
  def populate(%{name: 'getCS3', value: value}, acc) do
    put_in acc.info3.cs, value
  end
  def populate(%{name: 'getSS1', value: value}, acc) do
    number = String.to_integer(value)
    put_in acc.info1.ss, number
  end
  def populate(%{name: 'getSS2', value: value}, acc) do
    number = String.to_integer(value)
    put_in acc.info2.ss, number
  end
  def populate(%{name: 'getSS3', value: value}, acc) do
    number = String.to_integer(value)
    put_in acc.info3.ss, number
  end
  def populate(%{name: 'getRG1', value: value}, acc) do
    put_in acc.info1.rg, value
  end
  def populate(%{name: 'getRG2', value: value}, acc) do
    put_in acc.info2.rg, value
  end
  def populate(%{name: 'getRG3', value: value}, acc) do
    put_in acc.info3.rg, value
  end
  def populate(%{name: 'getPA1', value: value}, acc) do
    put_in acc.info1.pa, value
  end
  def populate(%{name: 'getPA2', value: value}, acc) do
    put_in acc.info2.pa, value
  end
  def populate(%{name: 'getPA3', value: value}, acc) do
    put_in acc.info3.pa, value
  end
  def populate(%{name: 'getLAN', value: value}, acc) do
    %{acc | lan: value}
  end
  def populate(%{name: 'getCYN', value: value}, acc) do
    %{acc | cyn: value}
  end
  def populate(%{name: 'getCYT', value: value}, acc) do
    %{acc | cyt: value}
  end
  def populate(%{name: 'getRTI', value: value}, acc) do
    %{acc | rti: value}
  end
  def populate(%{name: 'getDAT', value: value}, acc) do
    %{acc | dat: value}
  end

end