# MagicFlute

Play music programatically with Elixir

## Visual Model

```text
  +-------------+
  |             |
  |  Conductor  | Keeps track of the beat and when the performance ends. 
  |             | Gives time queues to the ensemble (players)
  +------+------+
       |
       |
       | Timing instructions
       |
       v
  +------+------+
  |             |
  |  Player(s)  | Plays notes using timing from Conductor
  |             |
  +-------------+
  ```

## Target Idea

* Players distrited on separate nodes
* Run node on device (phone or such)
* Modify note sheet / chords by user input on device

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `magic_flute` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:magic_flute, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/magic_flute](https://hexdocs.pm/magic_flute).
