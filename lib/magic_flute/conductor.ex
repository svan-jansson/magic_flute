defmodule MagicFlute.Conductor do
  @timeout 30_000

  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def stop() do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(__MODULE__) do
      GenServer.stop(pid, :normal, @timeout)
    end

    DynamicSupervisor.stop(__MODULE__)
  end

  def add_player(child_spec) do
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def tick_event(bar, beat) do
    notify_players(bar, beat)
  end

  defp notify_players(bar, beat) do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(__MODULE__) do
      GenServer.cast(pid, {:conductor_tick, bar, beat})
    end

    :ok
  end
end
