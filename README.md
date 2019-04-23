# MagicFlute

Play music using Elixir

## Visual Model

```text
+-------------+
|             |
|  Conductor  | Keeps track of beat
|             |
+------+------+
       |
       |
       | Timing instructions
       |
       v
+------+------+
|             |
|  Player(s)  | Plays after sheet notes
|             | using timing from Conductor
+-------------+
```

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
