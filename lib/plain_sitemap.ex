defmodule PlainSitemap do
  use Application

  def start(_type, _args) do
    PlainSitemap.Supervisor.start_link
  end

  defmacro __using__(opts) do
    quote location: :keep do
      unquote(config(opts))
      import unquote(__MODULE__), only: [urlset: 1, add: 1, add: 2]
      import XmlBuilder
    end
  end

  defmacro urlset([do: block]) do
    quote location: :keep do
      @default_output_dir "priv/static"
      @output_file_name "sitemap.xml.gz"
      def render do
        PlainSitemap.Generator.flush
        unquote(block)
        current_datetime = Timex.now
        doc(:urlset, unquote(__MODULE__).urlset_attributes, Enum.map(PlainSitemap.Generator.urlset, fn({path, opts}) ->
          element(:url, %{}, [
            element(:loc, "#{opts[:host] || @default_host}#{path}"),
            element(:lastmod, (opts[:lastmod] || current_datetime) |> unquote(__MODULE__).timezone_string),
            element(:changefreq, opts[:changefreq] || "daily"),
            element(:priority, opts[:priority] || 1.0)
          ])
        end))
      end
      def refresh do
        {:ok, _} = Application.ensure_all_started(@app)
        path = Application.app_dir(@app) |> Path.join(Application.get_env(:plain_sitemap, :output_dir, @default_output_dir)) |> Path.join(@output_file_name)
        {:ok, file} = File.open path, [:utf8, :write, :compressed]
        IO.write file, render()
        File.close file
      end
    end
  end

  defmacro add(path, opts \\ []) do
    quote location: :keep do
      PlainSitemap.Generator.add(unquote(path), unquote(opts))
    end
  end

  def urlset_attributes do
    %{
      :"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
      :"xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd",
      :"xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9",
      :"xmlns:image" => "http://www.google.com/schemas/sitemap-image/1.1",
      :"xmlns:video" => "http://www.google.com/schemas/sitemap-video/1.1",
      :"xmlns:geo" => "http://www.google.com/geo/schemas/sitemap/1.0",
      :"xmlns:news" => "http://www.google.com/schemas/sitemap-news/0.9",
      :"xmlns:mobile" => "http://www.google.com/schemas/sitemap-mobile/1.0",
      :"xmlns:pagemap" => "http://www.google.com/schemas/sitemap-pagemap/1.0",
      :"xmlns:xhtml" => "http://www.w3.org/1999/xhtml"
    }
  end

  def timezone_string(datetime) do
    datetime |> Timex.format!("%FT%T%:z", :strftime)
  end

  defp config(opts) do
    quote do
      @app unquote(opts)[:app] || raise ":app must be given."
      @default_host unquote(opts)[:default_host] || raise ":default_host must be given."
    end
  end
end
