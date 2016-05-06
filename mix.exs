defmodule PlainSitemap.Mixfile do
  use Mix.Project

  def project do
    [app: :plain_sitemap,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :xml_builder, :timex, :ecto],
     mod: {PlainSitemap, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:xml_builder, "~> 0.0.6"},
     {:timex, "~> 2.1"},
     {:ecto, "~> 1.1"}]
  end
end
