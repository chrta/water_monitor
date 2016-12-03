defmodule ExSyrServer.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @get_all_commands_reply_body ~r'<sc version="1.0"><d><c n="getSRN" /><c n="getSTA" /><c n="getMAC" /><c n="getDEN" /><c n="getDN1" /><c n="getDN2" /><c n="getDEV" /><c n="getSCR" /><c n="getVER" /><c n="getFIR" /><c n="getLGO" /><c n="getPRS" /><c n="getPST" /><c n="getWHU" /><c n="getOWH" /><c n="getIWH" /><c n="getFLO" /><c n="getRES" /><c n="getSCR" /><c n="getVS1" /><c n="getVS2" /><c n="getVS3" /><c n="getCS1" /><c n="getCS2" /><c n="getCS3" /><c n="getSS1" /><c n="getSS2" /><c n="getSS3" /><c n="getRG1" /><c n="getRG2" /><c n="getRG3" /><c n="getPA1" /><c n="getPA2" /><c n="getPA3" /><c n="getLAN" /><c n="getCYN" /><c n="getCYT" /><c n="getRTI" /><c n="getDAT" /><c n="setRCE" v="0" /></d></sc>'

@get_basic_commands_reply_body ~r'<sc version="1.0"><d><c n="getSRN" /><c n="getSTA" /><c n="getMAC" /><c n="getDEN" /><c n="getDN1" /><c n="getDN2" /><c n="getDEV" /><c n="getSCR" /><c n="getVER" /><c n="getFIR" /><c n="getLGO" /><c n="getPRS" /><c n="getPST" /><c n="getWHU" /><c n="getOWH" /><c n="getIWH" /><c n="getFLO" /><c n="getRES" /><c n="getSCR" /><c n="getVS1" /><c n="getVS2" /><c n="getVS3" /><c n="getCS1" /><c n="getCS2" /><c n="getCS3" /><c n="getSS1" /><c n="getSS2" /><c n="getSS3" /><c n="getRG1" /><c n="getRG2" /><c n="getRG3" /><c n="getPA1" /><c n="getPA2" /><c n="getPA3" /><c n="getLAN" /><c n="getCYN" /><c n="getCYT" /><c n="getRTI" /><c n="getDAT" /><c n="setRCE" v="0" /></d></sc>'

  @opts ExSyrServer.Router.init([])

  test "POST /GetBasicCommands" do
    conn = :post
    |> conn("/GetBasicCommands", """
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
    ) |> put_req_header("content-type", "application/x-www-form-urlencoded")
    
    # Invoke the plug
    conn = ExSyrServer.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ @get_basic_commands_reply_body
  end

  test "POST /GetAllCommands" do
    
    conn = :post
    |> conn("/GetAllCommands", """
xml=<?xml version="1.0" encoding='iso-8859-2'?>
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
<c n="getDAT" v="1234567890" />
</d>
</sc>
"""
    ) |> put_req_header("content-type", "application/x-www-form-urlencoded")

    # Invoke the plug
    conn = ExSyrServer.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ @get_all_commands_reply_body
  end



  test "post /WebServices/SyrConnectLimexWebService.asmx/SetPortInfo" do

    conn = :post
    |> conn("/WebServices/SyrConnectLimexWebService.asmx/SetPortInfo", """
xml=<?xml version="1.0" encoding="utf-8"?>
<sc>
<d>
<c n="getSRN" v="123456789" />
</d>
<pl>
<p n="1234" v="1" />
<p n="5678" v="1" />
</pl>
<cs v="9a4"/>
</sc>
"""
    )

    # Invoke the plug
    conn = ExSyrServer.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
  end

  test "post /WebServices/SyrConnectLimexWebService.asmx/GetBasicCommands" do

    conn = :post |> conn("/WebServices/SyrConnectLimexWebService.asmx/GetBasicCommands", """
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
) |> put_req_header("content-type", "application/x-www-form-urlencoded")

    # Invoke the plug
    conn = ExSyrServer.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ ~r'xml version'
  end

   test "POST /WebServices/SyrConnectLimexWebService.asmx/GetAllCommands" do
    conn = conn :post, "/WebServices/SyrConnectLimexWebService.asmx/GetAllCommands"

    # Invoke the plug
    conn = ExSyrServer.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 500
    assert conn.resp_body =~ ~r'befand sich auf Sperre Ressourcen aufgrund eines anderen Prozesses'
  end

end
