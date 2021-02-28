defmodule Twemoji.MixProject do
  use Mix.Project

  def project do
    [
      app: :twemoji,
      version: "0.2.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Twemoji for Elixir!",
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/ovyerus/twemoji-elixir"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:emojix, "~> 0.3.0"},
      {:floki, "~> 0.30.0"}
    ]
  end
end
