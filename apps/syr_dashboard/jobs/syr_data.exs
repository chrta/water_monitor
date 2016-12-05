use Kitto.Job.DSL

defmodule Kitto.Jobs.SyrDeviceInfo do

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
		 {_, %{^id => value}} -> fun.(%{value: value})
		 _ -> :skip
	       end
	end
      end
    end
  end
end

job :water_pressure_bar, do: Kitto.Jobs.SyrDeviceInfo.stream(:prs, &(broadcast!(:water_pressure_bar, &1)))

job :remaining_salt, do: Kitto.Jobs.SyrDeviceInfo.stream({:info1, :ss}, &(broadcast!(:remaining_salt, &1)))
