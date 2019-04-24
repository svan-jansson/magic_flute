defmodule MagicFlute.Note do
  @moduledoc """
  This module exposes the `~n` sigill, for quick notation:

  ```
  # C note in 3rd octave, with duration 10ms played with velocity *ppp*
  ~n(c3 10 ppp)

  # G# note in 2nd negative octave, with duration 10ms played with velocity *mf*
  ~n(g#-2 10 mf)
  ```

  ## Musical Dynamics

  The velocities are defined according to **Logic Pro 9 dynamics**. Source: [Musical Dynamics on Wikipedia](https://en.wikipedia.org/wiki/Dynamics_(music)).

  ```
  :ppp  # 16
  :pp   # 32
  :p    # 48
  :mp   # 64
  :mf   # 80
  ;f    # 96
  :ff   # 112
  :fff  # 127
  ```
  """

  @velocities %{
    ppp: 16,
    pp: 32,
    p: 48,
    mp: 64,
    mf: 80,
    f: 96,
    ff: 112,
    fff: 127
  }

  @notes [
    {"c", 0},
    {"c#", 1},
    {"db", 1},
    {"d", 2},
    {"d#", 3},
    {"eb", 3},
    {"e", 4},
    {"f", 5},
    {"f#", 6},
    {"gb", 6},
    {"g", 7},
    {"g#", 8},
    {"ab", 8},
    {"a", 9},
    {"a#", 10},
    {"bb", 10},
    {"b", 11}
  ]

  @scales %{
    major: [0, 2, 2, 1, 2, 2, 2, 1],
    minor: [0, 2, 1, 2, 2, 1, 2, 2],
    minor_harmonic: [0, 2, 1, 2, 2, 1, 3, 1],
    minor_melodic: [0, 2, 1, 2, 2, 2, 2, 1]
  }

  def sigil_n(string, []) when is_binary(string) do
    string
    |> String.split()
    |> List.to_tuple()
    |> parse_new()
  end

  def scale(scale, key, range \\ -2..8) do
    ratios = Map.get(@scales, scale, :invalid_scale)
    base_note = parse_base_note(key)

    Enum.map(range, fn octave ->
      base_in_octave = calculate_note(base_note, octave)

      {notes, _} =
        Enum.reduce(ratios, {[], base_in_octave}, fn ratio, {acc, base} ->
          {[base + ratio | acc], base + ratio}
        end)

      notes |> Enum.reverse()
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp parse_new({note_string, duration_string, velocity_string}) do
    {
      note_string |> parse_note(),
      duration_string |> parse_duration(),
      velocity_string |> parse_velocity()
    }
  end

  defp calculate_note(base_note, octave)
       when base_note >= 0 and base_note <= 11 and octave >= -2 and octave <= 8 do
    case base_note + (octave + 2) * 12 do
      note when note > 127 -> :invalid_note
      note -> note
    end
  end

  defp calculate_note(_base_note, _octave) do
    :invalid_note
  end

  defp parse_note(base_note_string, octave_string) do
    base_note = parse_base_note(base_note_string)
    octave = String.to_integer(octave_string)
    calculate_note(base_note, octave)
  end

  # a#2
  defp parse_note(<<base::bytes-size(1)>> <> <<sign::bytes-size(1)>> <> <<octave::bytes-size(1)>>)
       when sign == "#" or sign == "b" do
    parse_note(base <> sign, octave)
  end

  # a-2
  defp parse_note(
         <<base::bytes-size(1)>> <> <<octave_sign::bytes-size(1)>> <> <<octave::bytes-size(1)>>
       )
       when octave_sign == "-" do
    parse_note(base, octave_sign <> octave)
  end

  # a#-2
  defp parse_note(
         <<base::bytes-size(1)>> <>
           <<sign::bytes-size(1)>> <> <<octave_sign::bytes-size(1)>> <> <<octave::bytes-size(1)>>
       )
       when octave_sign == "-" do
    parse_note(base <> sign, octave_sign <> octave)
  end

  # a4
  defp parse_note(<<base::bytes-size(1)>> <> <<octave::bytes-size(1)>>) do
    parse_note(base, octave)
  end

  defp parse_duration(duration_string) do
    String.to_integer(duration_string)
  end

  defp parse_velocity(velocity_string) do
    Map.get(@velocities, String.to_atom(velocity_string), :invalid_velocity)
  end

  defp parse_base_note(base_note_string) do
    Map.get(@notes |> Map.new(), base_note_string, :invalid_note)
  end
end
