defmodule Twemoji do
  @moduledoc """
  Documentation for `Twemoji`.
  """

  @twemoji_cdn "https://twemoji.maxcdn.com/2/72x72/"

  @type floki_node ::
          String.t() | {String.t(), [] | [{String.t(), String.t()}], [] | [floki_node()]}
  @type earmark_node ::
          String.t() | {String.t(), [] | [{String.t(), String.t()}], [] | [earmark_node()], %{}}
  @type ast :: [floki_node() | earmark_node()] | []

  # TODO: custom settings for cdn/format (e.g., svg emoji instead of png, or selfhosted/alt cdn)

  @spec parse(String.t() | ast()) :: String.t()
  def parse([]), do: ""

  def parse(input) do
    input
    |> parse_as_ast()
    |> case do
      {:ok, ast} -> Floki.raw_html(ast)
      {:error, _} -> input
    end
  end

  def parse_as_ast(input, opts \\ [])

  @spec parse_as_ast(String.t() | ast(), [any()]) :: {:ok, ast()} | {:error, String.t()}
  def parse_as_ast([], _opts), do: {:ok, []}

  def parse_as_ast([_ | _] = ast, opts) do
    result =
      with p_ast <- process_ast(ast),
           p when is_list(p) <- List.flatten(p_ast) do
        {:ok, p}
      else
        {:error, _} = e -> e
      end

    format = Keyword.get(opts, :format, :floki)

    with {:ok, ast} <- result,
         converted <- transpose_ast(ast, format) do
      {:ok, converted}
    else
      e -> e
    end
  end

  def parse_as_ast(input, opts) do
    with {:ok, ast} <- Floki.parse_fragment(input),
         {:ok, result} <- parse_as_ast(ast, opts) do
      {:ok, result}
    else
      {:error, _} = e -> e
    end
  end

  # Processor

  defp process_ast([_ | _] = ast) do
    Enum.map(ast, fn
      {tag, attrs, children} ->
        {tag, attrs, children |> process_ast() |> List.flatten()}

      # Case for Earmark AST
      {tag, attrs, children, extra} ->
        {tag, attrs, children |> process_ast() |> List.flatten(), extra}

      data when is_binary(data) ->
        data
        |> Emojix.scan()
        |> case do
          [] ->
            data

          emoji ->
            emoji
            |> Enum.map(fn em ->
              %{
                point: String.downcase(em.hexcode),
                description: em.description,
                re: Regex.compile!(em.unicode)
              }
            end)
            |> Enum.map(&process_emoji(&1, data))
        end
    end)
  end

  defp process_ast([]), do: []

  defp process_emoji(emoji, input) do
    input
    |> String.split(emoji.re, include_captures: true, trim: true)
    |> Enum.map(fn part ->
      cond do
        Regex.match?(emoji.re, part) ->
          {"img",
           [
             {"draggable", "false"},
             {"class", "twemoji"},
             {"alt", emoji.description},
             {"aria-label", emoji.description},
             {"src", to_cdn(emoji.point)}
           ], []}

        true ->
          part
      end
    end)
  end

  # Helpers

  defp to_cdn(point, ext \\ ".png"), do: @twemoji_cdn <> point <> ext

  defp transpose_ast([_ | _] = ast, format) do
    Enum.map(ast, fn
      {tag, attr, children} ->
        cond do
          format == :floki -> {tag, attr, transpose_ast(children, format)}
          format == :earmark -> {tag, attr, transpose_ast(children, format), %{}}
        end

      {tag, attr, children, %{} = extra} ->
        cond do
          format == :floki -> {tag, attr, transpose_ast(children, format)}
          format == :earmark -> {tag, attr, transpose_ast(children, format), extra}
        end

      x ->
        x
    end)
  end

  defp transpose_ast([], _format), do: []
end
