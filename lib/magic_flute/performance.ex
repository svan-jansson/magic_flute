defmodule MagicFlute.Performance do
  use GenServer

  @init_state %{
    status: :stopped,
    position: {0, 1},
    beats_per_bar: 16,
    bpm: 120
  }

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    {:ok, @init_state}
  end

  def start(bpm, {bars, beats}) do
    state =
      @init_state
      |> Map.put(:bpm, bpm)
      |> Map.put(:beats_per_bar, bars * beats)

    GenServer.call(__MODULE__, {:start, state})
  end

  def stop() do
    GenServer.stop(__MODULE__)
  end

  def handle_call({:start, state}, _from, _state) do
    {:reply, :ok,
     state
     |> Map.put(:status, :started)
     |> schedule_beats()}
  end

  def handle_info({:beat, {bar, beat}}, state) do
    MagicFlute.Conductor.tick_event(bar, beat)
    {:noreply, state}
  end

  def handle_info({:new_bar, state}, _state) do
    {:noreply, state |> schedule_beats()}
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
