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

### From string

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
# Can also control AST output format (:floki (default), or :earmark)
iex> Twemoji.parse_as_ast("Twemoji in Elixir 🎉", format: :earmark)
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
    ], [], %{}}
 ]}
```

### From AST

#### Floki

```elixir
iex> {:ok, x} = Floki.parse_fragment("Twemoji in Elixir 🎉")
{:ok, ["Twemoji in Elixir 🎉"]}
iex> Twemoji.parse(x)
"Twemoji in Elixir <img draggable=\"false\" class=\"twemoji\" alt=\"party popper\" aria-label=\"party popper\" src=\"https://twemoji.maxcdn.com/2/72x72/1f389.png\"/>"
iex> Twemoji.parse_as_ast(x)
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
```

#### Earmark

```elixir
iex> {:ok, x, _} = EarmarkParser.as_ast("Twemoji in Elixir 🎉")
{:ok, [{"p", [], ["Twemoji in Elixir ­🎉"], %{}}], []}
iex> Twemoji.parse(x)
"<p>Twemoji in Elixir <img draggable=\"false\" class=\"twemoji\" alt=\"party popper\" aria-label=\"party popper\" src=\"https://twemoji.maxcdn.com/2/72x72/1f389.png\"/></p>"
iex> Twemoji.parse_as_ast(x, format: :earmark)
{:ok,
 [
   {"p", [],
    [
      "Twemoji in Elixir ",
      {"img",
       [
         {"draggable", "false"},
         {"class", "twemoji"},
         {"alt", "party popper"},
         {"aria-label", "party popper"},
         {"src", "https://twemoji.maxcdn.com/2/72x72/1f389.png"}
       ], [], %{}}
    ], %{}}
 ]}
```

## License

This repository is licensed under the [MIT License](./LICENSE)

<!-- Documentation can be generated with
[ExDoc](https://github.com/elixir-lang/ex_doc) and published on
[HexDocs](https://hexdocs.pm). Once published, the docs can be found at
[https://hexdocs.pm/twemoji](https://hexdocs.pm/twemoji). -->
