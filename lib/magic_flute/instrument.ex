defmodule MagicFlute.Instrument do
  @moduledoc """

  Interface for fluidsynth. Uses .sf2 files. Follows General MIDI standard with 127 different sound settings.

  ## General MIDI
  The `MagicFlute.Instrument` assumes that the .sf2 file contains a synthesizer that follows [General MIDI](https://en.wikipedia.org/wiki/General_MIDI)

  ## Instrument Sounds and Variants

  ### Example

  General format: `{sound, variant}`

  The instrument sound bank Electric Grand Piano is represented like this:

  ```
  {:piano, 3}
  ```

  ### Instrument Sound Bank Variants

  #### Piano (:piano)

  1. Acoustic Grand Piano
  2. Bright Acoustic Piano
  3. Electric Grand Piano
  4. Honky-tonk Piano
  5. Electric Piano 1
  6. Electric Piano 2
  7. Harpsichord
  8. Clavinet

  #### Chromatic Percussion (:chromatic_percussion)

  1. Celesta
  2. Glockenspiel
  3. Music Box
  4. Vibraphone
  5. Marimba
  6. Xylophone
  7. Tubular Bells
  8. Dulcimer

  #### Organ (:organ)

  1. Drawbar Organ
  2. Percussive Organ
  3. Rock Organ
  4. Church Organ
  5. Reed Organ
  6. Accordion
  7. Harmonica
  8. Tango Accordion

  #### Guitar (:guitar)

  1. Acoustic Guitar (nylon)
  2. Acoustic Guitar (steel)
  3. Electric Guitar (jazz)
  4. Electric Guitar (clean)
  5. Electric Guitar (muted)
  6. Overdriven Guitar
  7. Distortion Guitar
  8. Guitar Harmonics

  #### Bass (:bass)

  1. Acoustic Bass
  2. Electric Bass (finger)
  3. Electric Bass (pick)
  4. Fretless Bass
  5. Slap Bass 1
  6. Slap Bass 2
  7. Synth Bass 1
  8. Synth Bass 2

  #### Strings (:strings)

  1. Violin
  2. Viola
  3. Cello
  4. Contrabass
  5. Tremolo Strings
  6. Pizzicato Strings
  7. Orchestral Harp
  8. Timpani

  #### Ensemble (:ensemble)

  1. String Ensemble 1
  2. String Ensemble 2
  3. Synth Strings 1
  4. Synth Strings 2
  5. Choir Aahs
  6. Voice Oohs
  7. Synth Choir
  8. Orchestra Hit

  #### Brass (:brass)

  1. Trumpet
  2. Trombone
  3. Tuba
  4. Muted Trumpet
  5. French Horn
  6. Brass Section
  7. Synth Brass 1
  8. Synth Brass 2

  #### Reed (:reed)

  1. Soprano Sax
  2. Alto Sax
  3. Tenor Sax
  4 Baritone Sax
  5. Oboe
  6. English Horn
  7. Bassoon
  8. Clarinet

  #### Pipe (:pipe)

  1. Piccolo
  2. Flute
  3. Recorder
  4. Pan Flute
  5. Blown bottle
  6. Shakuhachi
  7. Whistle
  8. Ocarina

  #### Synth Lead (:synth_lead)

  1. Lead 1 (square)
  2. Lead 2 (sawtooth)
  3. Lead 3 (calliope)
  4. Lead 4 (chiff)
  5. Lead 5 (charang)
  6. Lead 6 (voice)
  7. Lead 7 (fifths)
  8. Lead 8 (bass + lead)

  #### Synth Pad (:synth_pad)

  1. Pad 1 (new age)
  2. Pad 2 (warm)
  3. Pad 3 (polysynth)
  4. Pad 4 (choir)
  5. Pad 5 (bowed)
  6. Pad 6 (metallic)
  7. Pad 7 (halo)
  8. Pad 8 (sweep)

  #### Synth Effects (:synth_effects)

  1. FX 1 (rain)
  2. FX 2 (soundtrack)
  3. FX 3 (crystal)
  4. FX 4 (atmosphere)
  5. FX 5 (brightness)
  6. FX 6 (goblins)
  7. FX 7 (echoes)
  8. FX 8 (sci-fi)

  #### Ethnic (:ethnic)

  1. Sitar
  2. Banjo
  3. Shamisen
  4. Koto
  5. Kalimba
  6. Bagpipe
  7. Fiddle
  8. Shanai

  #### Percussive (:percussive)

  1. Tinkle Bell
  2. Agogo
  3. Steel Drums
  4. Woodblock
  5. Taiko Drum
  6. Melodic Tom
  7. Synth Drum
  8. Reverse Cymbal

  #### Sound effects (:sound_effects)

  1. Guitar Fret Noise
  2. Breath Noise
  3. Seashore
  4. Bird Tweet
  5. Telephone Ring
  6. Helicopter
  7. Applause
  8. Gunshot
  """

  @sounds %{
    piano: 1..8,
    chromatic_percussion: 9..16,
    organ: 17..24,
    guitar: 25..32,
    bass: 33..40,
    strings: 41..48,
    ensemble: 49..56,
    brass: 57..64,
    reed: 65..72,
    pipe: 73..80,
    synth_lead: 81..88,
    synth_pad: 89..96,
    synth_effects: 97..104,
    ethnic: 105..112,
    percussive: 113..120,
    sound_effects: 121..128
  }

  @doc """
  Plays a note `{tone, duration, velocity}` on the given instrument `{sound, variant}`.
  """
  def play(note, _instrument = {sound, variant}) do
    apply_note(note, sound_from_atom(sound), variant)
  end

  defp sound_from_atom(sound) do
    Map.get(@sounds, sound, -1)
  end

  defp apply_note({tone, duration, velocity}, sound.._, variant) when variant <= 8 do
    sound
    |> Kernel.+(variant)
    |> MidiSynth.change_program()

    MidiSynth.play(tone, duration, velocity)
    {tone, duration, velocity}
  end

  defp apply_note(_, _, _), do: :invalid_instrument_sound
end
