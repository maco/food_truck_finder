defmodule FoodTruckFinderWeb.MapLive do
  use FoodTruckFinderWeb, :live_view
  alias FoodTruckFinder.{Facility, Map, Util}

  @default_lon -122.41594524663745
  @default_lat 37.805885350100986

  def render(assigns) do
    ~H"""
    <p>Enter an address below to find all of San Francisco's mobile lunch options within 1.5km</p>
    <form phx-submit="submit" class="m-8">
      <label for="address">Address</label> <input type="text" name="address" />
      <input type="submit" value="Submit" class="border-2 border-sky-800 p-2" />
    </form>
    <div class="container mx-auto w-[80%]">
      <div class="w-full h-[500px] p-20 border-2 border-sky-500" id="map" phx-hook="Map"></div>
    </div>
    There are <%= @count %> options currently holding valid permits.
    """
  end

  def mount(_params, _session, socket) do
    count = Map.count_facilities() |> IO.inspect(label: "count")

    socket =
      put_on_map(@default_lon, @default_lat, socket)
      |> assign(:count, count)

    {:ok, socket}
  end

  def handle_event("submit", %{"address" => address}, socket) do
    params =
      URI.encode_query(
        %{
          q: address,
          format: :json,
          polygon: 1,
          addressdetails: 1
        },
        :rfc3986
      )

    [response] = Req.get!("https://nominatim.openstreetmap.org/search?" <> params).body
    lat = Util.fetch_as_float(response, "lat", @default_lat)
    lon = Util.fetch_as_float(response, "lon", @default_lon)
    socket = put_on_map(lon, lat, socket)

    {:noreply, socket}
  end

  @spec put_on_map(float(), float(), Phoenix.LiveView.Socket.t()) :: Phoenix.LiveView.Socket.t()
  defp put_on_map(lon, lat, socket) do
    facilities = Map.get_facilities(lon, lat)

    socket =
      Enum.reduce(facilities, socket, fn %Facility{} = facility, socket ->
        socket
        |> push_event("add_facility", facility)
      end)

    # recenter the map so search results are visible
    socket |> push_event("recenter", %{lon: lon, lat: lat})
  end
end
