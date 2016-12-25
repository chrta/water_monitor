defmodule ExSyrServer.SyrController do
  import Plug.Conn
  
  alias ExSyrServer.SyrXml
  
  require Logger


  @get_all_commands_reply_body '''
<?xml version="1.0" encoding="utf-8"?>
<sc version="1.0">
  <d>
    <c n="getSRN" v="" />
    <c n="getCNA" v="" />
    <c n="getDEN" v="" />
    <c n="getMAC" v="" />
    <c n="getMAN" v="" />
    <c n="getSTA" v="" />
    <c n="getALM" v="" />
    <c n="getCDE" v="" />
    <c n="getCS1" v="" />
    <c n="getCS2" v="" />
    <c n="getCS3" v="" />
    <c n="getCYN" v="" />
    <c n="getTYP" v="" />
    <c n="getCYT" v="" />
    <c n="getDWF" v="" />
    <c n="getFCO" v="" />
    <c n="getFIR" v="" />
    <c n="getFLO" v="" />
    <c n="getNOT" v="" />
    <c n="getPA1" v="" />
    <c n="getPA2" v="" />
    <c n="getPA3" v="" />
    <c n="getPRS" v="" />
    <c n="getPST" v="" />
    <c n="getRDO" v="" />
    <c n="getRES" v="" />
    <c n="getRG1" v="" />
    <c n="getRG2" v="" />
    <c n="getRG3" v="" />
    <c n="getRPD" v="" />
    <c n="getRPW" v="" />
    <c n="getRTI" v="" />
    <c n="getSCR" v="" />
    <c n="getSRE" v="" />
    <c n="getSS1" v="" />
    <c n="getSS2" v="" />
    <c n="getSS3" v="" />
    <c n="getSV1" v="" />
    <c n="getSV2" v="" />
    <c n="getSV3" v="" />
    <c n="getWHU" v="" />
    <c n="getTOR" v="" />
    <c n="getVER" v="" />
    <c n="getVS1" v="" />
    <c n="getVS2" v="" />
    <c n="getVS3" v="" />
    <c n="getOWH" v="" />
    <c n="getRTH" v="" />
    <c n="getRTM" v="" />
    <c n="getIWH" v="" />
    <c n="getDAT" v="" />
  </d>
</sc>
'''

  @spec xml(Plug.Conn.t, String.Chars.t) :: Plug.Conn.t
  defp xml(conn, data) do
    conn
    |> put_resp_header("content-type", "text/xml; charset=utf-8")
    |> put_resp_header("content-length", "#{Enum.count(data)}")
    |> send_resp(conn.status || 200, to_string(data))
  end

  @spec html(Plug.Conn.t, String.Chars.t) :: Plug.Conn.t
  defp html(conn, data) do
    conn
    |> put_resp_header("content-type", "text/html; charset=UTF-8")
    |> put_resp_header("content-length", "#{Enum.count(data)}")
    |> send_resp(conn.status || 200, to_string(data))
  end

  @doc """

  Handles the second POST request

  Now validation is done here. The reply is always ok.

  This is the request from the device
POST /WebServices/SyrConnectLimexWebService.asmx/SetPortInfo HTTP/1.1
Host: syrconnect.de
User-Agent: LEXplus Client
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: pl,en-us;q=0.7,en;q=0.3
Accept-Encoding: identity
Content-Type: application/x-www-form-urlencoded
Content-Length: 172
Connection: keep-alive

xml=<?xml version="1.0" encoding="utf-8"?>
<sc>
<d>
<c n="getSRN" v="123456789" />
</d>
<pl>
<p n="1234" v="1" />
<p n="5678" v="1" />
</pl>
<cs v="123"/>
</sc>
  """
  def set_port_info(conn, %{"xml" => xml_params}) do
    port_info =
      xml_params |> to_charlist |> SyrXml.parse_port_info
    Logger.debug "Port info: #{inspect(port_info)}"
    GenEvent.notify :syr_event_manager, {:port_info, port_info}
    body = '''
<?xml version="1.0" encoding="utf-8"?>
<sc>
  <pl>
    <p n="#{Enum.at port_info.pl, 0}" v="ok" />
    <p n="#{Enum.at port_info.pl, 1}" v="ok" />
  </pl>
</sc>
'''
    
    xml conn, body
  end


  @doc """

  Handles the last post request before the data flow is established

  Server response:

HTTP/1.1 200 OK
Cache-Control: private, max-age=0
Content-Type: text/xml; charset=utf-8
Server: Microsoft-IIS/8.5
X-AspNet-Version: 2.0.50727
X-Powered-By: ASP.NET
Date: Sat, 12 Nov 2016 13:56:25 GMT
Content-Length: 242

<?xml version="1.0" encoding="utf-8"?>
<sc version="1.0">
  <d>
    <c n="getSRN" v="" />
    <c n="getCNA" v="" />
    <c n="getDEN" v="" />
    <c n="getMAC" v="" />
    <c n="getSTA" v="" />
    <c n="getMAN" v="" />
  </d>
</sc>
  """
  def get_basic_commands(conn, _params) do
    body = '''
<?xml version="1.0" encoding="utf-8"?>
<sc version="1.0">
  <d>
    <c n="getSRN" v="" />
    <c n="getCNA" v="" />
    <c n="getDEN" v="" />
    <c n="getMAC" v="" />
    <c n="getSTA" v="" />
    <c n="getMAN" v="" />
  </d>
</sc>
'''

    conn
    |> xml(body)
  end

  @spec text(Plug.Conn.t, String.Chars.t) :: Plug.Conn.t
  defp text(conn, data) do
    conn
    |> put_resp_header("content-type", "text/plain; charset=utf-8")
    |> put_resp_header("content-length", "#{Enum.count(data)}")
    |> send_resp(conn.status || 200, to_string(data))
  end

  @doc """
  Handles the post request to /WebServices/SyrConnectLimexWebService.asmx/GetAllCommands

  Currently a error 500 is returned

  """
  def get_all_commands(conn, %{"xml" => xml_params}) do
    state = xml_params |> to_charlist |> SyrXml.parse_complete_info
    Logger.debug "Device info: #{inspect(state)}"

    GenEvent.notify :syr_event_manager, {:state, state}
    xml conn, @get_all_commands_reply_body

  end
end
