defmodule MagicFlute.Player do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import MagicFlute.Player
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

      @before_compile MagicFlute.Player
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def read_notes(_bar, _beat) do
        []
      end

      def play_notes(notes) do
        Enum.map(notes, fn {note, duration, velocity} ->
          Task.async(fn -> play_note(note, duration, velocity) end)
        end)
        |> Enum.map(&Task.await/1)
      end

      def play_note(note, duration, velocity) do
        MagicFlute.Instrument.play(note, duration, velocity, @instrument)
      end
    end
  end
end
