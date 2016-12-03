defmodule ExSyrServer.SyrController do
  import Plug.Conn
  
  alias ExSyrServer.SyrXml
  
  require Logger


  @get_all_commands_reply_body '<sc version="1.0"><d><c n="getSRN" /><c n="getSTA" /><c n="getMAC" /><c n="getDEN" /><c n="getDN1" /><c n="getDN2" /><c n="getDEV" /><c n="getSCR" /><c n="getVER" /><c n="getFIR" /><c n="getLGO" /><c n="getPRS" /><c n="getPST" /><c n="getWHU" /><c n="getOWH" /><c n="getIWH" /><c n="getFLO" /><c n="getRES" /><c n="getSCR" /><c n="getVS1" /><c n="getVS2" /><c n="getVS3" /><c n="getCS1" /><c n="getCS2" /><c n="getCS3" /><c n="getSS1" /><c n="getSS2" /><c n="getSS3" /><c n="getRG1" /><c n="getRG2" /><c n="getRG3" /><c n="getPA1" /><c n="getPA2" /><c n="getPA3" /><c n="getLAN" /><c n="getCYN" /><c n="getCYT" /><c n="getRTI" /><c n="getDAT" /><c n="setRCE" v="0" /></d></sc>'

  @get_basic_commands_reply_body '<sc version="1.0"><d><c n="getSRN" /><c n="getSTA" /><c n="getMAC" /><c n="getDEN" /><c n="getDN1" /><c n="getDN2" /><c n="getDEV" /><c n="getSCR" /><c n="getVER" /><c n="getFIR" /><c n="getLGO" /><c n="getPRS" /><c n="getPST" /><c n="getWHU" /><c n="getOWH" /><c n="getIWH" /><c n="getFLO" /><c n="getRES" /><c n="getSCR" /><c n="getVS1" /><c n="getVS2" /><c n="getVS3" /><c n="getCS1" /><c n="getCS2" /><c n="getCS3" /><c n="getSS1" /><c n="getSS2" /><c n="getSS3" /><c n="getRG1" /><c n="getRG2" /><c n="getRG3" /><c n="getPA1" /><c n="getPA2" /><c n="getPA3" /><c n="getLAN" /><c n="getCYN" /><c n="getCYT" /><c n="getRTI" /><c n="getDAT" /><c n="setRCE" v="0" /></d></sc>'


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
    Logger.info "Received well fomed port information"
    Logger.debug "Port info: #{inspect(port_info)}"
    GenEvent.notify :syr_event_manager, {:port_info, port_info}
    
    xml conn, '<?xml version="1.0" encoding="utf-8"?>'
  end


  @doc """

  Handles the third post request

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
  def get_all_commands(conn, _params) do
    body = 'Die Transaktion (Prozess-ID 109) befand sich auf Sperre Ressourcen aufgrund eines anderen Prozesses in einer Deadlocksituation und wurde als Deadlockopfer ausgew&#228;hlt. F&#252;hren Sie die Transaktion erneut aus.'
    conn
    |> put_status(500)
    |> text(body)
  end


  @doc """
  Handles the /GetBasicCommands POST request

The request contains this:

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

  def get_basic_commands_2(conn, %{"body" => body}) do
    device_info = body |> to_charlist |> SyrXml.parse_device_info
    Logger.info "Received well formed device information"
    Logger.debug "Device info: #{inspect(device_info)}"

    GenEvent.notify :syr_event_manager, {:device_info, device_info}
    html conn, @get_basic_commands_reply_body
  end

  @doc """
  Handles post request to http://connect.saocal.pl/GetAllCommands
  """
  def get_all_commands_2(conn, %{"xml" => xml_params}) do
    state = xml_params |> to_charlist |> SyrXml.parse_complete_info
    Logger.info "Received well formed device state"
    Logger.debug "Device info: #{inspect(state)}"

    GenEvent.notify :syr_event_manager, {:state, state}
    xml conn, @get_all_commands_reply_body
  end

end
