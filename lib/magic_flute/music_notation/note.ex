defmodule MagicFlute.MusicNotation.Note do
  @moduledoc """
  Translates note literals into MIDI note values
  """

  @typedoc """
  Notes can be described as strings or atoms

  ** String Notes **

  ```
  "c"
  "c#"
  "db"
  "d"
  "d#"
  "eb"
  "e"
  "f"
  "f#"
  "gb"
  "g"
  "g#"
  "ab"
  "a"
  "a#"
  "bb"
  "b"
  ```

  ** Atom Notes **

  ```
  :c
  :c_sharp
  :d_flat
  :d
  :d_sharp
  :e_flat
  :e
  :f
  :f_sharp
  :g_flat
  :g
  :g_sharp
  :a_flat
  :a
  :a_sharp
  :b_flat
  :b
  ```
  """
  @type t() ::
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
    {"c", :c, 0},
    {"c#", :c_sharp, 1},
    {"db", :d_flat, 1},
    {"d", :d, 2},
    {"d#", :d_sharp, 3},
    {"eb", :e_flat, 3},
    {"e", :e, 4},
    {"f", :f, 5},
    {"f#", :f_sharp, 6},
    {"gb", :g_flat, 6},
    {"g", :g, 7},
    {"g#", :g_sharp, 8},
    {"ab", :a_flat, 8},
    {"a", :a, 9},
    {"a#", :a_sharp, 10},
    {"bb", :b_flat, 10},
    {"b", :b, 11}
  ]

  @doc """
  Converts a note literal to a MIDI note pitch
  """
  @spec to_midi(t()) :: 0..11 | :invalid_note
  def to_midi(literal) do
    parse_base_note(literal)
  end

  @doc """
  Converts a note literal to a MIDI note pitch, adjusted to given octave
  """
  @spec to_midi(t(), -2..8) :: 0..127 | :invalid_note | :invalid_octave
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
        fn {string, _atom, _base_note_index} -> string == base_note end,
        :invalid_base_note
      )

    base_note_index
  end

  defp parse_base_note(base_note) when is_atom(base_note) do
    {_string, _atom, base_note_index} =
      Enum.find(
        @base_notes,
        fn {_string, atom, _base_note_index} -> atom == base_note end,
        :invalid_base_note
      )

    base_note_index
  end

  defp parse_base_note(_base_note) do
    :invalid_base_note
  end
end
