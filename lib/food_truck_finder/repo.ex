defmodule FoodTruckFinder.Repo do
  use Ecto.Repo,
    otp_app: :food_truck_finder,
    adapter: Ecto.Adapters.Postgres
end
