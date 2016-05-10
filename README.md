# PlainSitemap

PlainSitemap is a simple sitemap generator for Elixir.

## Installation

Add plain_sitemap to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:plain_sitemap, github: "kenta-aktsk/plain_sitemap"}]
end
```

Ensure plain_sitemap is started before your application:

```elixir
def application do
  [applications: [:plain_sitemap]]
end
```

## Usage

(Assume that your app name is `my_app`, your site url is `http://example.com`, and you have `Entry` model)

Add module and define urlset like below:

```elixir
# web/sitemap.ex
defmodule MyApp.Sitemap do
  use PlainSitemap, app: :my_app, default_host: "http://example.com"
  alias MyApp.{Repo, Entry}

  urlset do
    add "/", changefreq: "hourly", priority: 1.0
    Entry |> Repo.all |> Enum.each(fn(entry) ->
      add "/entries/#{entry.id}", lastmod: entry.updated_at, changefreq: "daily", priority: 0.5
    end)
  end
end
```

Now You can generate sitemap on iex like below:
(output path is `priv/static/sitemap.xml.gz`)

```
MyApp.Sitemap.refresh
```

And you can generate sitemap by using `rpc` call to compiled package:
(output path is `lib/my_app-{version}/priv/static/sitemap.xml.gz`)

```
bin/my_app rpc Elixir.MyApp.Sitemap refresh
```

Generated sitemap example is below:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<urlset xmlns=...>
  <url>
    <loc>http://example.com/</loc>
    <lastmod>2016-04-10T10:10:10+00:00</lastmod>
    <changefreq>hourly</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>http://example.com/entries/1</loc>
    <lastmod>2016-04-20T02:02:02+00:00</lastmod>
    <changefreq>daily</changefreq>
    <priority>0.5</priority>
  </url>
  ...
</urlset>
```

## Supported Options to add

Similar to [sitemap_generator](https://github.com/kjvarga/sitemap_generator#supported-options-to-add).

  * `expires` option is not supported.


## Datetime support

PlainSitemap support `Ecto.DateTime` and `Timex.DateTime`.
