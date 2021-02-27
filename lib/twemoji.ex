defmodule Twemoji do
  @moduledoc """
  Documentation for `Twemoji`.
  """

  @twemoji_cdn "https://twemoji.maxcdn.com/2/72x72/"

  # TODO: custom settings for cdn/format (e.g., svg emoji instead of png, or selfhosted/alt cdn)

  @spec parse(String.t()) :: String.t()
  def parse(input) do
    input
    |> parse_as_ast()
    |> case do
      {:ok, ast} -> Floki.raw_html(ast)
      {:error, _} -> input
    end
  end

  @spec parse_as_ast(String.t()) :: {:ok, Floki.html_tree()} | {:error, String.t()}
  def parse_as_ast(input) do
    with {:ok, ast} <- Floki.parse_fragment(input),
         p_ast <- process_ast(ast),
         p when is_list(p) <- List.flatten(p_ast) do
      {:ok, p}
    else
      {:error, _} = e -> e
    end
  end

  defp process_ast([_ | _] = ast) do
    Enum.map(ast, fn
      {tag, attrs, children} ->
        {tag, attrs, children |> process_ast() |> List.flatten()}

      data when is_binary(data) ->
        data
        |> Emojix.scan()
        |> case do
          [] ->
            data

          _ = emoji ->
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

  defp to_cdn(point, ext \\ ".png"), do: @twemoji_cdn <> point <> ext
end
