defmodule QueryChaos do
  @moduledoc """
  This can be used to generate long query strings, e.g.

   QueryChaos.field_names(10_000)
   |> QueryChaos.shallow_query()
   |> IO.inspect(printable_limit: :infinity)

  """
  def field_names(limit), do: for(n <- 1..limit, do: "test#{n}")

  def deep_query([]), do: ""

  def deep_query([field | rest] = _fields) do
    "{ #{field} #{deep_query(rest)} }"
  end

  def shallow_query([]), do: ""

  def shallow_query([field | rest] = _fields) do
    "{ #{field} { #{Enum.join(rest, " ")} } }"
  end
end
