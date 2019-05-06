defmodule MagicFlute.MusicNotation.Duration do
  @moduledoc """
  Translates musical note length notation to clock time
  """

  @typedoc "A duration is described in milliseconds"
  @type t() :: pos_integer() | :invalid_duration

  @typedoc "A duration type can be a string or an atom"
  @type duration_type() ::
          String.t() | :whole | :half | :quarter | :eighth | :sixteenth | :thirtysecondth

  @duration_ratios %{
    whole: 1 / 1,
    half: 1 / 2,
    quarter: 1 / 4,
    eight: 1 / 8,
    sixteenth: 1 / 16,
    thirtysecondth: 1 / 32
  }

  @doc """
  Converts a note duration string to time in milliseconds

  ## Examples

      iex> MagicFlute.MusicNotation.Duration.to_milliseconds("50")
      50

  """
  @spec to_milliseconds(duration_type()) :: t()
  def to_milliseconds(duration_string) when is_binary(duration_string) do
    try do
      String.to_integer(duration_string)
    rescue
      ArgumentError -> :invalid_duration
    end
  end

  @doc """
  Converts a note duration atom to milliseconds using a bpm to calculate the timeframe.

  ## Examples

      iex> MagicFlute.MusicNotation.Duration.to_milliseconds(:whole, 120)
      500

  """
  @spec to_milliseconds(duration_type(), pos_integer()) :: t()
  def to_milliseconds(duration, bpm) when is_atom(duration) and is_integer(bpm) do
    try do
      @duration_ratios
      |> Map.get(duration)
      |> Kernel.*(1_000)
      |> Kernel.*(60)
      |> Kernel./(bpm)
    rescue
      _ -> :invalid_duration
    end
  end
end
