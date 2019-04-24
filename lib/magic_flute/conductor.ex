defmodule MagicFlute.Conductor do
  @moduledoc """

  > Conducting: The art of directing the simultaneous performance of several players or singers by the use of gesture. -Sir George Grove, John Alexander Fuller-Maitland

  The Conductor is the entrypoint for playing a performance. She keeps the beat, knows when to end the performance and instructs the instrumentalists (`MagicFlute.Player`) when to play their notes.

  ```text
  +-------------+
  |             |
  |  Conductor  | Keeps track of the beat and when the performance ends.
  |             | Gives time queues to the ensemble (players)
  +------+------+
       |
       |
       | Timing instructions
       |
       v
  +------+------+
  |             |
  |  Player(s)  | Plays notes using timing from Conductor
  |             |
  +-------------+
  ```
  """
  use DynamicSupervisor
  alias MagicFlute.Conductor.{Performance, Instructions}

  @timeout 30_000

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [nil]},
      type: :supervisor
    }
  end

  @doc false
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc false
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a new performance with a given ensemble (players), bpm and time signature. The length of the performance, in bars, must also be passed. The performance will continue on until all bars are passed, regardless of the state of the ensemble.
  """
  def start_performance(ensemble, bpm, signature, length_in_bars) do
    %{active: active} = DynamicSupervisor.count_children(__MODULE__)
    start(ensemble, bpm, signature, length_in_bars, active > 0)
  end

  @doc """
  Will end the current performance and free up the Conductor for the next one.
  """
  def end_performance() do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(__MODULE__) do
      GenServer.stop(pid, :normal, @timeout)
    end

    DynamicSupervisor.stop(__MODULE__)
    {:ok, :ended}
  end

  defp start(ensemble, bpm, signature, length_in_bars, _running = false) do
    DynamicSupervisor.start_child(
      __MODULE__,
      Performance.child_spec(bpm, signature, length_in_bars)
    )

    DynamicSupervisor.start_child(__MODULE__, Instructions.child_spec(ensemble))
    {:ok, :started}
  end

  defp start(_ensemble, _bpm, _signature, _length_in_bars, _running = true) do
    {:error, :already_started}
  end
end
