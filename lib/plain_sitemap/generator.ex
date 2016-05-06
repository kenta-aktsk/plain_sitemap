defmodule PlainSitemap.Generator do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add(path, opts) do
    entry = {path, opts}
    Agent.update(__MODULE__, &([entry | &1]))
  end

  def flush do
    Agent.update(__MODULE__, fn(_) -> [] end)
  end

  def urlset do
    Agent.get(__MODULE__, &(&1 |> Enum.reverse))
  end
end
