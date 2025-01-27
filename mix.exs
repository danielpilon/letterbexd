defmodule Letterbexd.MixProject do
  use Mix.Project

  def project do
    [
      app: :letterbexd,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Letterbexd.Application, [env: Mix.env()]},
      applications: applications(Mix.env())
    ]
  end

  defp applications(:test), do: applications(:default) ++ [:cowboy, :plug]
  defp applications(_), do: [:httpoison]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:httpoison, "~> 1.7"},
      {:floki, "~> 0.27.0"},
      {:html_entities, "~> 0.5.1"},
      {:nimble_csv, "~> 0.7.0"},
      {:plug_cowboy, "~> 2.3"}
    ]
  end
end
