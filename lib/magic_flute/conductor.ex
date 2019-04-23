defmodule MagicFlute.Conductor do
  use DynamicSupervisor
  alias MagicFlute.Conductor.{Performance, Instructions}

  @timeout 30_000

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_performance(players, bpm, signature) do
    %{active: active} = DynamicSupervisor.count_children(__MODULE__)
    start(players, bpm, signature, active > 0)
  end

  defp start(players, bpm, signature, _running = false) do
    DynamicSupervisor.start_child(__MODULE__, Performance.child_spec(bpm, signature))
    DynamicSupervisor.start_child(__MODULE__, Instructions.child_spec(players))
    {:ok, :started}
  end

  defp start(_players, _bpm, _signature, _running = true) do
    {:error, :already_started}
  end

  def end_performance() do
    clear_children()
    DynamicSupervisor.stop(__MODULE__)
    {:ok, :ended}
  end

  defp clear_children do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(__MODULE__) do
      GenServer.stop(pid, :normal, @timeout)
    end
  end
end
