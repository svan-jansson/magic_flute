defmodule MagicFlute.Conductor.Instructions do
  @moduledoc false

  @timeout 30_000

  use Supervisor

  def child_spec(ensemble) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [ensemble]},
      type: :supervisor,
      restart: :transient
    }
  end

  def start_link(ensemble) do
    Supervisor.start_link(__MODULE__, ensemble, name: __MODULE__)
  end

  def init(ensemble) do
    Supervisor.init(ensemble, strategy: :one_for_one)
  end

  def get_latency() do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.map(fn {id, pid, _, _} ->
      {id, GenServer.call(pid, :latency)}
    end)
  end

  def stop() do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.each(fn {_, pid, _, _} ->
      GenServer.stop(pid, :normal, @timeout)
    end)

    Supervisor.stop(__MODULE__)
    :noop
  end

  def give_instructions_to_ensemble(bar, beat, timestamp) do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.each(fn {_, pid, _, _} ->
      GenServer.cast(pid, {:signal, bar, beat, timestamp})
    end)

    :noop
  end
end
