defmodule MagicFlute.Player do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import MagicFlute.Player
      use GenServer

      @instrument Keyword.get(opts, :instrument)

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
        {:ok, nil}
      end

      def handle_cast({:signal, bar, beat}, state) do
        play(bar, beat)
        {:noreply, state}
      end

      @before_compile MagicFlute.Player
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def play(_bar, _beat) do
        :noop
      end

      def play_note(note, duration, velocity) do
        MagicFlute.Instrument.play(note, duration, velocity, @instrument)
      end

      def play_chord(notes, duration, velocity) do
        Enum.map(notes, fn note ->
          Task.async(fn -> play_note(note, duration, velocity) end)
        end)
        |> Enum.each(&Task.await/1)
      end
    end
  end
end
