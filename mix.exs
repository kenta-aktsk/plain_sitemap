defmodule PlainSitemap.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :plain_sitemap,
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,

     # Hex
     description: description,
     package: package]
  end

  defp description do
    """
    Very simple sitemap generator for Elixir inspired by sitemap_generator.
    """
  end

  defp package do
    [maintainers: ["Kenta Katsumata"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/kenta-aktsk/plain_sitemap"},
     files: ~w(mix.exs README.md LICENSE lib)]
  end

  def application do
    [applications: [:logger, :xml_builder, :timex, :ecto],
     mod: {PlainSitemap, []}]
  end

  defp deps do
    [{:xml_builder, "~> 0.0.6"},
     {:timex, "~> 2.1"},
     {:ecto, "~> 1.1"}]
  end
end
