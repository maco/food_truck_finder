defmodule FoodTruckFinder.Facility do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:address, :name, :type, :latitude, :longitude]}
  schema "facilities" do
    field :address, :string
    field :location_id, :integer
    field :point, Geo.PostGIS.Geometry
    field :name, :string
    field :latitude, :float
    field :longitude, :float
    field :type, Ecto.Enum, values: [:truck, :cart]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(facility, attrs) do
    facility
    |> cast(attrs, [:location_id, :name, :point, :latitude, :longitude, :address, :type])
    |> validate_required([:location_id, :name, :point, :latitude, :longitude, :address, :type])
  end
end
