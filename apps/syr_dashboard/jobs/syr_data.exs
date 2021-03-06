use Kitto.Job.DSL

defmodule Kitto.Jobs.SyrDeviceInfo do

  defp get_date_time_string(epoch) do
    epoch |> DateTime.from_unix! |> DateTime.to_string
  end

  defp notify(:dat, value, fun) do
    fun.(%{text: get_date_time_string(value)})
  end

  defp notify(_, value, fun) do
    fun.(%{value: value})
  end

  def stream(id, fun) do
    Task.start_link fn ->
      stream = GenEvent.stream(:syr_event_manager)
      
      # call fun for all events
      for event <- stream do
	case id do
	  {main_id, sub_id} -> case event do
				 {_, %{^main_id => %{^sub_id => value}}} -> fun.(%{value: value})
				 _ -> :skip
			       end
	  _ -> case event do
		 {_, %{^id => value}} -> notify(id, value, fun)
		 _ -> :skip
	       end
	end
      end
    end
  end
end

job :water_pressure_bar, do: Kitto.Jobs.SyrDeviceInfo.stream(:prs, &(broadcast!(:water_pressure_bar, &1)))

job :remaining_salt, do: Kitto.Jobs.SyrDeviceInfo.stream({:info1, :ss}, &(broadcast!(:remaining_salt, &1)))

job :remaining_capacity, do: Kitto.Jobs.SyrDeviceInfo.stream(:res, &(broadcast!(:remaining_capacity, &1)))

job :water_flow_lpm, do: Kitto.Jobs.SyrDeviceInfo.stream(:flo, &(broadcast!(:water_flow_lpm, &1)))

job :device_date_time, do: Kitto.Jobs.SyrDeviceInfo.stream(:dat, &(broadcast!(:device_date_time, &1)))
