defmodule FoodTruckFinder.Repo.Migrations.CreateFacilities do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis;"

    create table(:facilities) do
      add :location_id, :integer
      add :name, :string
      add :address, :string
      add :type, :string
      add :latitude, :float
      add :longitude, :float

      timestamps(type: :utc_datetime)
    end

    execute("SELECT AddGeometryColumn('facilities', 'point', 4326, 'POINT', 2)")
    execute("CREATE INDEX facilities_point_index on facilities USING gist (point)")
  end

  def down do
    drop(table(:facilities))
    execute("DROP EXTENSION IF EXISTS postgis")
  end
end
