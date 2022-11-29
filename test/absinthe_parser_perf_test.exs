defmodule AbsintheParserPerfTest do
  use ExUnit.Case
  doctest AbsintheParserPerf

  # gonna need it...
  @moduletag timeout: :infinity

  test "benchmark simple query" do
    {time, result} = :timer.tc(&AbsintheParserPerf.query_placeholder/0)
    IO.puts("placeholder query time was #{time / 1_000_000} sec")
    {:ok, %{data: %{"placeholder" => "Hello world"}}} = result
  end

  test "time exactly 15000 tokens" do
    query = AbsintheParserPerf.generate_exactly_15000_tokens_query()
    {time, result} = :timer.tc(&Absinthe.run/2, [query, Schema])
    IO.puts("exactly 15k tokens query time was #{time / 1_000_000} sec")
    {:ok, %{errors: errors}} = result
    assert Enum.find(errors, &(&1.message =~ "Cannot query field"))
  end

  test "10k bogus directives" do
    {time, result} = :timer.tc(&AbsintheParserPerf.query_directives_attack/0)
    IO.puts("10k directive query time was #{time / 1_000_000} sec")
    {:ok, %{errors: errors}} = result
    assert Enum.find(errors, &(&1.message =~ "Unknown directive"))
  end

  test "10k bogus fields (deep nesting)" do
    {time, result} = :timer.tc(&AbsintheParserPerf.deep_query_invalid_fields/0)
    IO.puts("10k deep query time was #{time / 1_000_000} sec")
    {:ok, %{errors: errors}} = result
    assert Enum.find(errors, &(&1.message =~ "Cannot query field"))
  end

  test "10k bogus fields (shallow nesting)" do
    {time, result} = :timer.tc(&AbsintheParserPerf.shallow_query_invalid_fields/0)
    IO.puts("10k shallow query time was #{time / 1_000_000} sec")
    {:ok, %{errors: errors}} = result
    assert Enum.find(errors, &(&1.message =~ "Cannot query field"))
  end
end
