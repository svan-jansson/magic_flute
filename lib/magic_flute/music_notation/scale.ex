defmodule MagicFlute.MusicNotation.Scale do
  @moduledoc """
  Generates notes ranges for musical scales
  """

  alias MagicFlute.MusicNotation.Note

  @typedoc """
  Atoms describing musical scales: `:major, :minor, :minor_harmonic, :minor_melodic, :chromatic, :whole_tone, :diminished`
  """
  @type t() ::
          :invalid_scale
          | :major
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
  Returns a list of notes in the given scale
  """
  @spec scale(Note.t(), t(), Range.t()) :: list(Note.t())
  def scale(note, scale, range \\ -2..8) do
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
