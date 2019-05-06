defmodule MagicFlute.MusicNotation.Chord do
  @moduledoc """
  Helpers for describing chords as list of MIDI note values
  """

  alias MagicFlute.MusicNotation.Note

  @components [
    {"", :major_triad, [0, 4, 7]},
    {"6", :major_sixth, [0, 4, 7, 9]},
    {"7", :dominant_major_seventh, [0, 4, 7, 10]},
    {"M7", :major_seventh, [0, 4, 7, 11]},
    {"+", :augumented_triad, [0, 4, 8]},
    {"+7", :augumented_seventh, [0, 4, 8, 10]},
    {"m", :minor_triad, [0, 3, 7]},
    {"m6", :minor_sixth, [0, 3, 7, 9]},
    {"m7", :minor_seventh, [0, 3, 7, 10]},
    {"mM7", :minor_major_seventh, [0, 3, 7, 11]},
    {"dim", :diminished_triad, [0, 3, 6]},
    {"dim7", :diminished_seventh, [0, 3, 6, 9]},
    {"ø", :half_diminished_seventh, [0, 3, 6, 1]}
  ]

  @typedoc "A chord consists of a list of notes"
  @type t() :: list(pos_integer()) | :invalid_chord

  @typedoc "A chord type can be described as strings or atoms"
  @type chord_type() ::
          String.t()
          | :major_triad
          | :major_sixth
          | :dominant_major_seventh
          | :major_seventh
          | :augumented_triad
          | :augumented_seventh
          | :minor_triad
          | :minor_sixth
          | :minor_seventh
          | :minor_major_seventh
          | :diminished_triad
          | :diminished_seventh
          | :half_diminished_seventh

  @doc """
  Returns a chord for the given chord literal and octave

  ## Examples

      iex> MagicFlute.MusicNotation.Chord.get_notes("Am", 2)
      [57, 60, 64]

  """
  @spec get_notes(String.t(), pos_integer()) :: t()
  def get_notes(literal, octave) when is_binary(literal) and is_integer(octave) do
    get_notes(literal, octave..octave)
  end

  @doc """
  Returns a chord for the given chord literal and octave range

  ## Examples

      iex> MagicFlute.MusicNotation.Chord.get_notes("Am", 2..2)
      [57, 60, 64]

  """
  @spec get_notes(String.t(), Range.t()) :: t()
  def get_notes(literal = <<key::bytes-size(1)>> <> chord, range)
      when is_binary(literal) and is_map(range) do
    get_notes(key, chord, range)
  end

  @doc """
  Returns a chord for the given key, chord type and octave range

  ## Examples

      iex> MagicFlute.MusicNotation.Chord.get_notes(:a, :minor_triad, 2..2)
      [57, 60, 64]

  """
  @spec get_notes(Note.t(), chord_type(), Range.t()) :: t()
  def get_notes(key, chord, range) do
    try do
      range
      |> Enum.reduce([], fn octave, acc ->
        base_note = Note.to_midi(key, octave)

        notes =
          chord
          |> parse_chord()
          |> Enum.map(fn component ->
            base_note + component
          end)

        [notes | acc]
      end)
      |> Enum.reverse()
      |> List.flatten()
    rescue
      _ -> :invalid_chord
    end
  end

  defp parse_chord(chord) when is_binary(chord) do
    {_string, _atom, components} =
      Enum.find(
        @components,
        :invalid_chord,
        fn {string, _atom, _components} -> string == chord end
      )

    components
  end

  defp parse_chord(chord) when is_atom(chord) do
    {_string, _atom, components} =
      Enum.find(
        @components,
        :invalid_chord,
        fn {_string, atom, _components} -> atom == chord end
      )

    components
  end
end
