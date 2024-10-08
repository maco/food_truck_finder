alias FoodTruckFinder.{Facility, Util}

System.get_env("CSV_PATH", "Mobile_Food_Facility_Permit.csv")
|> File.stream!()
|> CSV.decode(headers: true)
|> Enum.each(fn
  {:ok, %{"Status" => "APPROVED"} = entry} ->
    # only worry about locations with valid permits
    location_id = Map.get(entry, "locationId", nil)
    name = Map.get(entry, "Applicant", "")
    address = Map.get(entry, "Address", nil)

    type =
      case Map.get(entry, "FacilityType", nil) do
        "Truck" -> :truck
        "Push Cart" -> :cart
        _ -> nil
      end

    latitude = Util.fetch_as_float(entry, "Latitude")
    longitude = Util.fetch_as_float(entry, "Longitude")

    # only insert entries with valid location data
    case {longitude, latitude} do
      {lon, lat} when not is_nil(lon) and not is_nil(lat) ->
        point = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}

        FoodTruckFinder.Repo.insert!(%Facility{
          location_id: location_id,
          name: name,
          latitude: latitude,
          longitude: longitude,
          point: point,
          address: address,
          type: type
        })

      _ ->
        :ok
    end

  _ ->
    :ok
end)
