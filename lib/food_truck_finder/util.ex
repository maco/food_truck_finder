defmodule FoodTruckFinder.Util do
  @doc """
  Returns a float-version of a map key, if possible. If `key` does not exist or
  the value cannot be parsed as a float, `default` is returned.

  ## Examples
      iex> FoodTruckFinder.Util.fetch_as_float(%{foo: "1.5"}, :foo)
      1.5

      iex> FoodTruckFinder.Util.fetch_as_float(%{"foo" => "1.5"}, "foo")
      1.5

      iex> FoodTruckFinder.Util.fetch_as_float(%{"foo" => "bar"}, "foo")
      nil

      iex > FoodTruckFinder.Util.fetch_as_float(%{"foo" => "bar"}, "foo", 12.0)
      12.0
  """
  @spec fetch_as_float(Map.t(), term(), float() | nil) :: float | nil
  def fetch_as_float(map, key, default \\ nil) do
    with {:ok, raw_value} <- Map.fetch(map, key),
         {floaty_value, _} <- Float.parse(raw_value) do
      floaty_value
    else
      _ ->
        default
    end
  end
end
