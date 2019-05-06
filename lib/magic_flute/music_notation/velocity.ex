defmodule MagicFlute.MusicNotation.Velocity do
  @moduledoc """
  Translates musical dynamics notation to MIDI note velocity
  """

  @typedoc "A velocity is described using a MIDI integer value"
  @type t() :: 0..127 | :invalid_velocity

  @typedoc "A velocity type is described with a string or an atom"
  @type velocity_type() ::
          String.t()
          | :ppp
          | :pp
          | :p
          | :mp
          | :mf
          | :f
          | :ff
          | :fff

  @doc """
  Converts a velocity atom to a MIDI note velocity

  The available note velocities according to **Logic Pro 9 dynamics**. Source: [Musical Dynamics on Wikipedia](https://en.wikipedia.org/wiki/Dynamics_(music)).

  ```
  :ppp  # 16
  :pp   # 32
  :p    # 48
  :mp   # 64
  :mf   # 80
  :f    # 96
  :ff   # 112
  :fff  # 127
  ```
  """
  @spec to_midi(velocity_type()) :: t()
  def to_midi(string) when is_binary(string) do
    string |> String.to_existing_atom() |> to_midi()
  end

  def to_midi(:ppp), do: 16
  def to_midi(:pp), do: 32
  def to_midi(:p), do: 48
  def to_midi(:mp), do: 64
  def to_midi(:mf), do: 80
  def to_midi(:f), do: 96
  def to_midi(:ff), do: 112
  def to_midi(:fff), do: 127
  def to_midi(_), do: :invalid_velocity
end
