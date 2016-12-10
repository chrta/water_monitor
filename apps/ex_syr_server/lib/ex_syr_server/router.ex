defmodule ExSyrServer.Router do
  use Plug.Router

  alias ExSyrServer.SyrController


  plug :register_before_send_plug, func: &ExSyrServer.Router.before_send/1
  plug :match
  plug :dispatch

  @webservices "/WebServices/SyrConnectLimexWebService.asmx"

  @doc"""
  Registers the given function to be called before sending the response
  """
  def register_before_send_plug(conn, opts) do
    conn |> register_before_send(opts[:func])
  end

  @doc"""
  Modifies the response headers for the syr device

  It only unterstands upper case, e.g. Content-Length
  """
  @spec before_send(Plug.Conn.t) :: Plug.Conn.t
  def before_send(conn) do
    %{conn | resp_headers: Enum.map(conn.resp_headers, fn({key, value}) ->
         key = key
         |> String.split("-")
         |> Enum.map(fn(key) -> String.capitalize(key) end)
         |> Enum.join("-")
         {key, value}
       end)}
  end

  @doc"""
  Handles POST http://connect.saocal.pl/GetBasicCommands
  """
  post "/GetBasicCommands" do
    {:ok, body, conn} = conn |> read_body
    SyrController.get_basic_commands_2 conn, %{"body" => body}
  end

  @doc"""
  Handles POST http://connect.saocal.pl/GetAllCommands
  """
  post "/GetAllCommands" do
    {:ok, body, conn} = conn |> read_body
    "xml=" <> xml_params = body
    SyrController.get_all_commands_2 conn, %{"xml" => xml_params}
  end


  @doc"""
  Handles POST http://syrconnect.consoft.de/WebServices/SyrConnectLimexWebService.asmx/SetPortInfo
  """
  post @webservices <> "/SetPortInfo" do
    {:ok, body, conn} = conn |> read_body
    "xml=" <> xml_params = body
    SyrController.set_port_info conn, %{"xml" => xml_params}
  end

  @doc"""
  Handles POST http://syrconnect.consoft.de/WebServices/SyrConnectLimexWebService.asmx/GetBasicCommands
  """
  post @webservices <> "/GetBasicCommands" do
    SyrController.get_basic_commands conn, %{}
  end

  @doc"""
  Handles POST http://syrconnect.consoft.de/WebServices/SyrConnectLimexWebService.asmx/GetAllCommands
  """
  post @webservices <> "/GetAllCommands" do
    SyrController.get_all_commands conn, %{}
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
