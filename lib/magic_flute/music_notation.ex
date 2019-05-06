defmodule MagicFlute.MusicNotation do
  @moduledoc """
  This module defines musical notation and helpers to describe musical notes in Elixir
  """

  alias MagicFlute.MusicNotation.{Duration, Note, Velocity}

  @type t() :: {Note.t(), Duration.t(), Velocity.t()}

  @doc """
  The `~n` sigill allows you to quickly describe a *note* (hence *~n*). It converts the input data to a tuple `{tone, duration, velocity}` that can be used with MIDI interfaces.

  ```
  # C note in 3rd octave, with duration 10ms played with velocity ppp (pianissimo)
  ~n(C3 10 ppp)

  # G# note in 2nd negative octave, with duration 10ms played with velocity mf (mezzo-forte)
  ~n(G#-2 10 mf)
  ```
  """
  def sigil_n(string, []) when is_binary(string) do
    string
    |> String.split()
    |> List.to_tuple()
    |> to_midi()
  end

  @spec to_midi({String.t(), String.t(), String.t()}) :: t()
  def to_midi({note_string, duration_string, velocity_string}) do
    {
      note_string |> parse_note(),
      duration_string |> Duration.to_milliseconds(),
      velocity_string |> Velocity.to_midi()
    }
  end

  # Handles case: "a#2"
  defp parse_note(<<base::bytes-size(1)>> <> <<sign::bytes-size(1)>> <> <<octave::bytes-size(1)>>)
       when sign == "#" or sign == "b" do
    parse_note(base <> sign, octave)
  end

  # Handles case: "a-2"
  defp parse_note(
         <<base::bytes-size(1)>> <> <<octave_sign::bytes-size(1)>> <> <<octave::bytes-size(1)>>
       )
       when octave_sign == "-" do
    parse_note(base, octave_sign <> octave)
  end

  # Handles case: "a#-2"
  defp parse_note(
         <<base::bytes-size(1)>> <>
           <<sign::bytes-size(1)>> <> <<octave_sign::bytes-size(1)>> <> <<octave::bytes-size(1)>>
       )
       when octave_sign == "-" do
    parse_note(base <> sign, octave_sign <> octave)
  end

  # Handles case: "a2"
  defp parse_note(<<base::bytes-size(1)>> <> <<octave::bytes-size(1)>>) do
    parse_note(base, octave)
  end

  defp parse_note(base_note_string, octave_string) do
    octave = String.to_integer(octave_string)
    Note.to_midi(base_note_string, octave)
  end
end
