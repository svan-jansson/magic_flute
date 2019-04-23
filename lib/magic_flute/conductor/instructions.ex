defmodule MagicFlute.Conductor.Instructions do
  @timeout 30_000

  use Supervisor

  def child_spec(players) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [players]},
      type: :supervisor
    }
  end

  def start_link(players) do
    Supervisor.start_link(__MODULE__, players, name: __MODULE__)
  end

  def init(players) do
    Supervisor.init(players, strategy: :one_for_one)
  end

  def stop() do
    for {_, pid, _, _} <- Supervisor.which_children(__MODULE__) do
      GenServer.stop(pid, :normal, @timeout)
    end

    Supervisor.stop(__MODULE__)
  end

  def signal(bar, beat) do
    notify_players(bar, beat)
  end

  defp notify_players(bar, beat) do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(__MODULE__) do
      GenServer.cast(pid, {:signal, bar, beat})
    end

    :ok
  end
end
