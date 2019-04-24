defmodule MagicFlute.Conductor.Performance do
  @moduledoc false

  use GenServer

  alias MagicFlute.Conductor

  @init_state %{
    status: :started,
    position: {1, 1},
    signature: {4, 4},
    bpm: 120,
    length_in_bars: 16
  }

  def child_spec(bpm, signature, length_in_bars) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [bpm, signature, length_in_bars]},
      type: :supervisor,
      restart: :transient
    }
  end

  def start_link(bpm, signature, length_in_bars) do
    state =
      @init_state
      |> Map.put(:bpm, bpm)
      |> Map.put(:signature, signature)
      |> Map.put(:length_in_bars, length_in_bars)

    result = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    Process.send_after(__MODULE__, {:new_bar, state}, 500)
    result
  end

  def init(nil) do
    {:ok, nil}
  end

  def stop() do
    GenServer.stop(__MODULE__)
  end

  def handle_info(
        {:new_bar,
         %{
           :length_in_bars => length_in_bars,
           :position => {bar, _beat}
         }},
        state
      )
      when bar > length_in_bars do
    Conductor.Instructions.stop()
    {:stop, :normal, state}
  end

  def handle_info({:new_bar, state}, _state) do
    {:noreply, state |> schedule_beats()}
  end

  def handle_info({:beat, {bar, beat}}, state) do
    Conductor.Instructions.give_instructions_to_ensemble(bar, beat, :erlang.system_time())
    {:noreply, state}
  end

  defp schedule_beats(
         state = %{
           bpm: bpm,
           signature: {signature_beat, signature_subdivision},
           position: {bar, _beat}
         }
       ) do
    bar_length = bpm_to_ms(bpm) * signature_beat
    subdivisions = signature_beat * signature_subdivision
    beat_length = (bar_length / subdivisions) |> Kernel.trunc()

    # Schedule next whole beat
    Process.send_after(__MODULE__, {:new_bar, %{state | position: {bar + 1, 1}}}, bar_length)

    # Schedule current beat's subdivisions
    Enum.each(1..subdivisions, fn beat ->
      Process.send_after(__MODULE__, {:beat, {bar, beat}}, beat_length * beat)
    end)

    state
  end

  defp bpm_to_ms(bpm), do: (60 / bpm * 1000) |> Kernel.trunc()
end
