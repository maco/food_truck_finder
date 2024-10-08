defmodule FoodTruckFinder.Util do
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
