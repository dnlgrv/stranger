defmodule Stranger.Mixfile do
  use Mix.Project

  def project do
    [app: :stranger,
     version: "0.0.2",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [mod: {Stranger, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext,
                    :html_sanitize_ex]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.1.2"},
     {:phoenix_html, "~> 2.3"},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:exrm, "~> 1.0.0-rc7"},
     {:html_sanitize_ex, "~> 0.1.0"},

     {:phoenix_live_reload, "~> 1.0", only: :dev}]
  end
end
