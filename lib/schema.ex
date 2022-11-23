defmodule Schema do
  use Absinthe.Schema

  query do
    @desc "Doesn't matter what the schema is, just define a placeholder field"
    field :placeholder, :string do
      resolve(fn _, _ ->
        {:ok, "Hello world"}
      end)
    end
  end
end
