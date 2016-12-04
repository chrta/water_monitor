use Kitto.Job.DSL

defmodule Kitto.Jobs.SyrDeviceInfo do
  use GenEvent

  require Logger

  def stream(fun) do
    Task.start_link fn ->
      stream = GenEvent.stream(:syr_event_manager)
      
      # call fun for all events
      for event <- stream do
	case event do
	  {_, %{prs: pressure}} -> fun.(%{value: pressure})
	  _ -> :skip
	end
      end
    end
  end

  # Callbacks

  def handle_event({:state, x}, messages) do
    Logger.warn "New state #{inspect(x)}"
    {:ok, [x | messages]}
  end

   def handle_event({:port_info, x}, messages) do
     Logger.warn "New port_info #{inspect(x)}"    
     {:ok, [x | messages]}
   end

   def handle_event({:device_info, x}, messages) do
     Logger.warn "New device_info #{inspect(x)}"    
     {:ok, [x | messages]}
   end

  def handle_call(:messages, messages) do
    {:ok, Enum.reverse(messages), []}
  end
  
end

GenEvent.add_handler(:syr_event_manager, Kitto.Jobs.SyrDeviceInfo, [])

job :syr_device_info, do: Kitto.Jobs.SyrDeviceInfo.stream(&(broadcast!(:syr_device_info, &1)))
