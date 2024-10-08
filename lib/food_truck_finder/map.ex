defmodule FoodTruckFinder.Map do
  import Ecto.Query
  import Geo.PostGIS

  alias FoodTruckFinder.Repo
  alias FoodTruckFinder.Facility

  def get_facilities(longitude, latitude) do
    goal = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}
    query = Facility |> where([f], st_dwithin_in_meters(^goal, f.point, 1_500))
    Repo.all(query)
  end

  def count_facilities() do
    query = from(f in Facility)
    Repo.aggregate(query, :count)
  end
end
