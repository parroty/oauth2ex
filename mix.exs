defmodule OAuth2Ex.Mixfile do
  use Mix.Project

  def project do
    [app: :oauth2ex,
     version: "0.0.2",
     elixir: "~> 0.15.0",
     description: description,
     package: package,
     test_coverage: [tool: ExCoveralls],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison, :cowboy, :plug]]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:httpoison, github: "edgurgel/httpoison"},
      {:jsex, "~> 2.0"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 0.6.0"},
      # {:cowboy, "~> 1.0.0", optional: true},
      # {:plug, "~> 0.6.0", optional: true},
      {:timex, "~> 0.12"},
      {:excoveralls, "~> 0.3", only: :dev}
    ]
  end

  defp description do
    """
    An OAuth 2.0 client library for elixir.
    """
  end

  defp package do
    [ contributors: ["parroty"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/parroty/oauth2ex"} ]
  end
end
