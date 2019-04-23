defmodule MagicFlute.Conductor.Performance do
  use GenServer

  @init_state %{
    status: :started,
    position: {1, 1},
    beats_per_bar: 16,
    bpm: 120
  }

  def child_spec(bpm, signature) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [bpm, signature]},
      type: :supervisor
    }
  end

  def start_link(bpm, {bars, beats}) do
    state =
      @init_state
      |> Map.put(:bpm, bpm)
      |> Map.put(:beats_per_bar, bars * beats)

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

  def handle_info({:new_bar, state}, _state) do
    {:noreply, state |> schedule_beats()}
  end

  def handle_info({:beat, {bar, beat}}, state) do
    MagicFlute.Conductor.Instructions.signal(bar, beat)
    {:noreply, state}
  end

  defp schedule_beats(
         state = %{
           bpm: bpm,
           beats_per_bar: beats_per_bar,
           position: {bar, _beat}
         }
       ) do
    bar_length = bpm_to_ms(bpm)
    beat_length = (bar_length / beats_per_bar) |> Kernel.trunc()

    # Schedule next whole beat
    Process.send_after(__MODULE__, {:new_bar, %{state | position: {bar + 1, 1}}}, bar_length)

    # Schedule current beat's subdivisions
    Enum.each(1..beats_per_bar, fn beat ->
      Process.send_after(__MODULE__, {:beat, {bar, beat}}, beat_length * beat)
    end)
  end

  defp bpm_to_ms(bpm), do: (60 / bpm * 1000) |> Kernel.trunc()
end
