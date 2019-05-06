defmodule MagicFlute.MusicNotation.Scale do
  @moduledoc """
  Generates notes ranges for musical scales
  """

  alias MagicFlute.MusicNotation.Note

  @typedoc "A scale consists of a list of MIDI note values"
  @type t() :: list(pos_integer()) | :invalid_scale

  @typedoc "Scale types are described as atoms"
  @type scale_type() ::
          :major
          | :minor
          | :minor_harmonic
          | :minor_melodic
          | :chromatic
          | :whole_tone
          | :diminished

  @scale_steps %{
    major: [0, 2, 2, 1, 2, 2, 2, 1],
    minor: [0, 2, 1, 2, 2, 1, 2, 2],
    minor_harmonic: [0, 2, 1, 2, 2, 1, 3, 1],
    minor_melodic: [0, 2, 1, 2, 2, 2, 2, 1],
    chromatic: [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    whole_tone: [0, 2, 2, 2, 2, 2],
    diminished: [0, 2, 1, 2, 1, 2, 1, 2]
  }

  @doc """
  Returns a list of notes for a given scale, tone and octave range.

  ```
  # Return all notes in the C Major scale for the 2nd and 3rd octave
  MagicFlute.MusicNotation.Scale.get_notes("C", :major, 2..3)

  # Return all notes in the G# Harmonic Minor scale for the 3rd octave
  MagicFlute.MusicNotation.Scale.get_notes("G#", :minor_harmonic, 3..3)
  ```
  """
  @spec get_notes(Note.t(), scale_type(), Range.t()) :: t()
  def get_notes(note, scale, range \\ -2..8) do
    ratios = Map.get(@scale_steps, scale, :invalid_scale)

    Enum.map(range, fn octave ->
      base_in_octave = Note.to_midi(note, octave)

      {notes, _} =
        Enum.reduce(ratios, {[], base_in_octave}, fn ratio, {acc, base} ->
          {[base + ratio | acc], base + ratio}
        end)

      notes |> Enum.reverse()
    end)
    |> List.flatten()
    |> Enum.uniq()
  end
end
