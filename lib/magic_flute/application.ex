defmodule MagicFlute.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {MagicFlute.Performance, [name: MagicFlute.Performance]},
      {MagicFlute.Conductor, [name: MagicFlute.Conductor]}
    ]

    opts = [strategy: :one_for_one, name: MagicFlute.Supervisor]
    Supervisor.start_link(children, opts)
  end
end