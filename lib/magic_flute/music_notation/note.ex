defmodule MagicFlute.MusicNotation.Note do
  @moduledoc """
  Translates note literals into MIDI note values
  """

  @typedoc "A note is represented by its MIDI integer value"
  @type t() :: 0..127 | :invalid_note | :invalid_octave

  @typedoc "Note types can be described as strings or atoms"
  @type note_type() ::
          String.t()
          | :c
          | :c_sharp
          | :d_flat
          | :d
          | :d_sharp
          | :e_flat
          | :e
          | :f
          | :f_sharp
          | :g_flat
          | :g
          | :g_sharp
          | :a_flat
          | :a
          | :a_sharp
          | :b_flat
          | :b

  @base_notes [
    {"C", :c, 0},
    {"C#", :c_sharp, 1},
    {"Db", :d_flat, 1},
    {"D", :d, 2},
    {"D#", :d_sharp, 3},
    {"Eb", :e_flat, 3},
    {"E", :e, 4},
    {"F", :f, 5},
    {"F#", :f_sharp, 6},
    {"Gb", :g_flat, 6},
    {"G", :g, 7},
    {"G#", :g_sharp, 8},
    {"Ab", :a_flat, 8},
    {"A", :a, 9},
    {"A#", :a_sharp, 10},
    {"Bb", :b_flat, 10},
    {"B", :b, 11}
  ]

  @doc """
  Converts a note literal to a MIDI integer value
  """
  @spec to_midi(note_type()) :: t()
  def to_midi(literal) do
    parse_base_note(literal)
  end

  @doc """
  Converts a note literal to a MIDI note pitch, adjusted to given octave
  """
  @spec to_midi(note_type(), -2..8) :: t()
  def to_midi(literal, octave) do
    to_midi(literal)
    |> adjust_octave(octave)
  end

  defp adjust_octave(base_note, octave)
       when base_note >= 0 and base_note <= 11 and octave >= -2 and octave <= 8 do
    case base_note + (octave + 2) * 12 do
      note when note > 127 -> :invalid_octave
      note -> note
    end
  end

  defp adjust_octave(_base_note, _octave) do
    :invalid_octave
  end

  defp parse_base_note(base_note) when is_binary(base_note) do
    {_string, _atom, base_note_index} =
      Enum.find(
        @base_notes,
        :invalid_base_note,
        fn {string, _atom, _base_note_index} -> string == base_note end
      )

    base_note_index
  end

  defp parse_base_note(base_note) when is_atom(base_note) do
    {_string, _atom, base_note_index} =
      Enum.find(
        @base_notes,
        :invalid_base_note,
        fn {_string, atom, _base_note_index} -> atom == base_note end
      )

    base_note_index
  end

  defp parse_base_note(_base_note) do
    :invalid_base_note
  end
end
