# Let Ecto know we're going to use PostGIS extensions

Postgrex.Types.define(
  FoodTruckFinder.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
