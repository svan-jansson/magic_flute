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
    clear_children()
    DynamicSupervisor.start_child(__MODULE__, Performance.child_spec(bpm, signature))
    DynamicSupervisor.start_child(__MODULE__, Instructions.child_spec(players))
  end

  def end_performance() do
    clear_children()

    DynamicSupervisor.stop(__MODULE__)
  end

  defp clear_children do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(__MODULE__) do
      GenServer.stop(pid, :normal, @timeout)
    end
  end
end
