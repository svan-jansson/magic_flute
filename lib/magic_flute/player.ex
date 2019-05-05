defmodule MagicFlute.Player do
  @moduledoc """
  * The player plays a specific `MagicFlute.Instrument` sound setting.
  * The player reads notes and plays them on the queue of the `MagicFlute.Conductor`.

  ## Example

  ```
  defmodule FlutePlayer do

    use MagicFlute.Player, instrument: {:pipe, 2}

    # Will play '~n(d3 5 ff)' on the first beat of every bar in the performance
    def read_notes(bar, 1) do
      [
        ~n(d3 5 ff)
      ]
    end

    # Will play `~n(c3 5 mp)` on every quarter beat of every bar in the performance
    def read_notes(bar, beat) when beat == 5 or beat == 9 or beat == 13 do
      [
        ~n(c3 5 mp)
      ]
    end

    # Will play `~n(c3 5 pp)` on every eight beat of every bar in the performance
    def read_notes(bar, beat) when rem(beat, 2) != 0 do
      [
        ~n(c3 5 pp)
      ]
    end
  end
  ```
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import MagicFlute.Player
      import MagicFlute.MusicNotation

      use GenServer

      @instrument Keyword.get(opts, :instrument)

      @init_state %{
        previous_state: nil,
        previous_call_completed_in: 0
      }

      def child_spec(_) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, []},
          type: :worker
        }
      end

      def start_link() do
        GenServer.start_link(
          __MODULE__,
          :ok,
          name: __MODULE__
        )
      end

      def init(:ok) do
        {:ok, @init_state}
      end

      def handle_call(
            :latency,
            _from,
            state = %{
              :previous_call_completed_in => previous_call_completed_in
            }
          ) do
        {:reply, previous_call_completed_in, state}
      end

      def handle_cast({:signal, bar, beat, timestamp}, _state) do
        notes =
          read_notes(bar, beat)
          |> play_notes()

        completion_time = :erlang.system_time() - timestamp

        {:noreply,
         %{
           previous_state: %{
             notes: notes,
             position: {bar, beat}
           },
           previous_call_completed_in: completion_time
         }}
      end

      # Translate provided sheet notes to read_notes function definitions
      case Keyword.fetch(opts, :note_sheet) do
        {:ok, note_sheet} ->
          Enum.each(note_sheet, fn {bar_range, module, function} ->
            Enum.each(bar_range, fn bar ->
              def read_notes(unquote(bar), beat),
                do: apply(unquote(module), unquote(function), [unquote(bar), beat])
            end)
          end)

        {:error, _ingore} ->
          :note_sheet_not_provided
      end

      @before_compile MagicFlute.Player
    end
  end

  defmacro __before_compile__(_opts) do
    quote do
      def read_notes(_bar, _beat) do
        []
      end

      def play_notes(notes) do
        Enum.map(notes, fn note ->
          Task.async(fn -> play_note(note) end)
        end)
        |> Enum.map(&Task.await/1)
      end

      def play_note(note) do
        MagicFlute.Instrument.play(note, @instrument)
      end
    end
  end
end
