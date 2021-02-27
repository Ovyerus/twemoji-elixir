# twemoji-elixir

> Twemoji for Elixir!

## TODO

- Documentation
- Tests
- Currently doesn't support families (👪) and presumably other joined emojis
  (skintones, rainbow/transgender flags, etc.). Will need an update in
  [Emojix](https://github.com/ukita/emojix) to support em, may do it myself.

## Installation

Add it to `deps` in `mix.exs`

```elixir
def deps do
  [
    {:twemoji, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
iex> Twemoji.parse("Twemoji in Elixir 🎉")
"Twemoji in Elixir <img draggable=\"false\" class=\"twemoji\" alt=\"party popper\" aria-label=\"party popper\" src=\"https://twemoji.maxcdn.com/2/72x72/1f389.png\"/>"
iex> Twemoji.parse_as_ast("Twemoji in Elixir 🎉")
{:ok,
 [
   "Twemoji in Elixir ",
   {"img",
    [
      {"draggable", "false"},
      {"class", "twemoji"},
      {"alt", "party popper"},
      {"aria-label", "party popper"},
      {"src", "https://twemoji.maxcdn.com/2/72x72/1f389.png"}
    ], []}
 ]}
)
```

## License

This repository is licensed under the [MIT License](./LICENSE)

<!-- Documentation can be generated with
[ExDoc](https://github.com/elixir-lang/ex_doc) and published on
[HexDocs](https://hexdocs.pm). Once published, the docs can be found at
[https://hexdocs.pm/twemoji](https://hexdocs.pm/twemoji). -->
