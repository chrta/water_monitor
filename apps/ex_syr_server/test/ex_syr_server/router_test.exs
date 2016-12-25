defmodule ExSyrServer.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @get_all_commands_reply_body ~r'<c n="getSRN" v="" />\s*<c n="getCNA" v="" />\s*<c n="getDEN" v="" />\s*<c n="getMAC" v="" />\s*<c n="getMAN" v="" />\s*<c n="getSTA" v="" />\s*<c n="getALM" v="" />\s*<c n="getCDE" v="" />\s*<c n="getCS1" v="" />\s*<c n="getCS2" v="" />\s*<c n="getCS3" v="" />\s*<c n="getCYN" v="" />\s*<c n="getTYP" v="" />\s*<c n="getCYT" v="" />\s*<c n="getDWF" v="" />\s*<c n="getFCO" v="" />\s*<c n="getFIR" v="" />\s*<c n="getFLO" v="" />\s*<c n="getNOT" v="" />\s*<c n="getPA1" v="" />\s*<c n="getPA2" v="" />\s*<c n="getPA3" v="" />\s*<c n="getPRS" v="" />\s*<c n="getPST" v="" />\s*<c n="getRDO" v="" />\s*<c n="getRES" v="" />\s*<c n="getRG1" v="" />\s*<c n="getRG2" v="" />\s*<c n="getRG3" v="" />\s*<c n="getRPD" v="" />\s*<c n="getRPW" v="" />\s*<c n="getRTI" v="" />\s*<c n="getSCR" v="" />\s*<c n="getSRE" v="" />\s*<c n="getSS1" v="" />\s*<c n="getSS2" v="" />\s*<c n="getSS3" v="" />\s*<c n="getSV1" v="" />\s*<c n="getSV2" v="" />\s*<c n="getSV3" v="" />\s*<c n="getWHU" v="" />\s*<c n="getTOR" v="" />\s*<c n="getVER" v="" />\s*<c n="getVS1" v="" />\s*<c n="getVS2" v="" />\s*<c n="getVS3" v="" />\s*<c n="getOWH" v="" />\s*<c n="getRTH" v="" />\s*<c n="getRTM" v="" />\s*<c n="getIWH" v="" />'

  @opts ExSyrServer.Router.init([])

  test "POST /GetBasicCommands" do
    conn = :post
    |> conn("/GetBasicCommands", """
<?xml version='1.0' encoding='iso-8859-2'?>
<sc version="1.0">
<d>
<c n="getSRN" v="123456789" />
<c n="getMAC" v="11:22:33:44:55:66" />
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
    assert conn.status == 502
    assert conn.resp_body =~ ~r'Bad Gateway'
  end

  test "POST /GetAllCommands" do
    
    conn = :post
    |> conn("/GetAllCommands", "")
    |> put_req_header("content-type", "application/x-www-form-urlencoded")

    # Invoke the plug
    conn = ExSyrServer.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 502
    assert conn.resp_body =~ ~r'Bad Gateway'
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
<p n="1234" v="0" />
<p n="5678" v="0" />
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
    assert conn.resp_body =~ ~r'<sc>\s*<pl>\s*<p n="1234" v="ok" />\s*<p n="5678" v="ok" />\s*</pl>\s*</sc>'
  end

  test "post /WebServices/SyrConnectLimexWebService.asmx/GetBasicCommands" do

    conn = :post |> conn("/WebServices/SyrConnectLimexWebService.asmx/GetBasicCommands", "")
    |> put_req_header("content-type", "application/x-www-form-urlencoded")

    # Invoke the plug
    conn = ExSyrServer.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ ~r'<sc version="1.0">\s*<d>\s*<c n="getSRN" v="" />\s*<c n="getCNA" v="" />\s*<c n="getDEN" v="" />\s*<c n="getMAC" v="" />\s*<c n="getSTA" v="" />\s*<c n="getMAN" v="" />\s*</d>\s*</sc>'
  end

  test "POST /WebServices/SyrConnectLimexWebService.asmx/GetAllCommands (initial)" do
    
    conn = :post |> conn("/WebServices/SyrConnectLimexWebService.asmx/GetAllCommands", """
xml=<?xml version="1.0" encoding="utf-8"?>
<sc version="1.0">
<d>
<c n="getSRN" v="123456789" />
<c n="getCNA" v="LEXplus10" />
<c n="getDEN" v="1" />
<c n="getMAC" v="11:22:33:44:55:66" />
<c n="getSTA" v="" />
<c n="getMAN" v="Syr" />
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

    test "POST /WebServices/SyrConnectLimexWebService.asmx/GetAllCommands (data)" do
    
    conn = :post |> conn("/WebServices/SyrConnectLimexWebService.asmx/GetAllCommands", """
xml=<?xml version="1.0" encoding="utf-8"?>
<sc version="1.0">
<d>
<c n="getSRN" v="123456789" />
<c n="getCNA" v="LEXplus10" />
<c n="getDEN" v="1" />
<c n="getMAC" v="11:22:33:44:55:66" />
<c n="getMAN" v="Syr" />
<c n="getSTA" v="" />
<c n="getALM" v="" />
<c n="getCDE" v="031SCA59DF1927.01.024.1.1.0010" />
<c n="getCS1" v="58" />
<c n="getCS2" v="0" />
<c n="getCS3" v="0" />
<c n="getCYN" v="0" />
<c n="getTYP" v="80" />
<c n="getCYT" v="00:00" />
<c n="getDWF" v="200" />
<c n="getFCO" v="0" />
<c n="getFIR" v="SLP0" />
<c n="getFLO" v="0" />
<c n="getNOT" v="" />
<c n="getPA1" v="0" />
<c n="getPA2" v="0" />
<c n="getPA3" v="0" />
<c n="getPRS" v="38" />
<c n="getPST" v="0" />
<c n="getRDO" v="80" />
<c n="getRES" v="677" />
<c n="getRG1" v="0" />
<c n="getRG2" v="0" />
<c n="getRG3" v="0" />
<c n="getRPD" v="4" />
<c n="getRPW" v="0" />
<c n="getRTI" v="00:00" />
<c n="getSCR" v="0" />
<c n="getSRE" v="0" />
<c n="getSS1" v="8" />
<c n="getSS2" v="0" />
<c n="getSS3" v="0" />
<c n="getSV1" v="11" />
<c n="getSV2" v="0" />
<c n="getSV3" v="0" />
<c n="getWHU" v="0" />
<c n="getTOR" v="17" />
<c n="getVER" v="3.1" />
<c n="getVS1" v="0" />
<c n="getVS2" v="0" />
<c n="getVS3" v="0" />
<c n="getOWH" v="6" />
<c n="getRTH" v="1" />
<c n="getRTM" v="10" />
<c n="getIWH" v="25" />
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

end
