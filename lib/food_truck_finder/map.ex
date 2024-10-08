defmodule FoodTruckFinder.Map do
  import Ecto.Query
  import Geo.PostGIS

  alias FoodTruckFinder.Repo
  alias FoodTruckFinder.Facility

  @walking_distance_meters 1_500

  @spec get_facilities(float(), float()) :: %Facility{}
  def get_facilities(longitude, latitude) do
    goal = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}
    query = Facility |> where([f], st_dwithin_in_meters(^goal, f.point, @walking_distance_meters))
    Repo.all(query)
  end

  @spec count_facilities() :: integer()
  def count_facilities() do
    query = from(f in Facility)
    Repo.aggregate(query, :count)
  end
end
