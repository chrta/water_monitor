defmodule ExSyrServer.SyrXml do
  @moduledoc"""
  This module contains the code to convert the XML messages
  from/to the web server
  """

  alias ExSyrServer.SyrXml
  alias SyrXml.CompleteInformation
  alias SyrXml.PortInformation
  alias SyrXml.DeviceInformation

  import SweetXml

  def convert_to_string(%{value: x} = y) do
    %{y | value: to_string(x)}
  end

  def convert_to_string({:cs, %{cs: x} = y}) do
    {:cs, %{y | cs: to_string(x)}}
  end

  def convert_to_string({:pl, [%{n: x1} = y1, %{n: x2} = y2]}) do
    {:pl, [%{y1 | n: to_string x1}, %{y2 | n: to_string x2}]}
  end

  def convert_to_string({:serial, %{serial: x} = y}) do
    {:serial, %{y | serial: to_string x}}
  end

  def convert_to_string(x) do
    to_string x
  end

  @doc"""
  This parses the POST request body to http://connect.saocal.pl/GetBasicCommands

  doc: The xml document

  Example content:
  <?xml version='1.0' encoding='iso-8859-2'?>
  <sc version="1.0">
    <d>
      <c n="getSRN" v="162509513" />
      <c n="getMAC" v="70:b3:d5:19:4a:66" />
      <c n="getMAN" v="Syr" />
      <c n="getDEN" v="1" />
      <c n="getSTA" v=" " />
      <c n="getDAT" v="1478962590" />
      <c n="getCNA" v="LEXplus10" />
    </d>
  </sc>
  """
  def parse_device_info(doc) do
    doc |> parse(encoding: :"utf-8")
    |> xpath(
      ~x"//sc/d/c"l,
      name: ~x"./@n",
      value: ~x"./@v"
    )
    |> Stream.map(&SyrXml.convert_to_string(&1))
    |> Enum.reduce(%DeviceInformation{}, &DeviceInformation.populate/2)
  end

  @doc"""
  Parse the POST request to /WebServices/SyrConnectLimexWebService.asmx/SetPortInfo

E.g.
xml=<?xml version="1.0" encoding="utf-8"?>
<sc>
<d>
<c n="getSRN" v="123456789" />
</d>
<pl>
<p n="2883" v="1" />
<p n="8484" v="1" />
</pl>
<cs v="abc"/>
</sc>
  """
  def parse_port_info(doc) do
    doc |> parse(encoding: :"utf-8")
    |> xmap(
      serial: [
        ~x"//sc/d/c",
        serial: ~x"./@v"
      ],
    pl: [
      ~x"//sc/pl/p"l,
      n: ~x"./@n",
      v: ~x"./@v"
    ],
    cs: [
      ~x"//sc/cs",
      cs: ~x"./@v"
    ]
    )
    |> Stream.map(&SyrXml.convert_to_string(&1))
    |> Enum.reduce(%PortInformation{}, &PortInformation.populate/2)
  end

  @doc"""

  Example data:
<?xml version="1.0" encoding='iso-8859-2'?>
<sc version="1.0">
<d>
<c n="getSRN" v="123456789" />
<c n="getSTA" v="" />
<c n="getMAC" v="AA:BB:CC:DD:EE:FF" />
<c n="getDEN" v="1" />
<c n="getDN1" v="" />
<c n="getDN2" v="" />
<c n="getDEV" v="" />
<c n="getSCR" v="0" />
<c n="getVER" v="3.0" />
<c n="getFIR" v="SLP0" />
<c n="getLGO" v="1" />
<c n="getPRS" v="37" />
<c n="getPST" v="0" />
<c n="getWHU" v="0" />
<c n="getOWH" v="6" />
<c n="getIWH" v="25" />
<c n="getFLO" v="0" />
<c n="getRES" v="1149" />
<c n="getSCR" v="0" />
<c n="getVS1" v="0" />
<c n="getVS2" v="0" />
<c n="getVS3" v="0" />
<c n="getCS1" v="99" />
<c n="getCS2" v="0" />
<c n="getCS3" v="0" />
<c n="getSS1" v="13" />
<c n="getSS2" v="0" />
<c n="getSS3" v="0" />
<c n="getRG1" v="0" />
<c n="getRG2" v="0" />
<c n="getRG3" v="0" />
<c n="getPA1" v="0" />
<c n="getPA2" v="0" />
<c n="getPA3" v="0" />
<c n="getLAN" v="1" />
<c n="getCYN" v="0" />
<c n="getCYT" v="00:00" />
<c n="getRTI" v="00:00" />
<c n="getDAT" v="1111111111" />
</d>
</sc>

  """

  def parse_complete_info(doc) do
    doc |> parse(encoding: :"utf-8")
        |> xpath(
             ~x"//sc/d/c"l,
             name: ~x"./@n",
             value: ~x"./@v"
           )
        |> Stream.map(&SyrXml.convert_to_string(&1))
        |> Enum.reduce(%CompleteInformation{}, &CompleteInformation.populate/2)
  end
end
