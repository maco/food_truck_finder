defmodule FoodTruckFinder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FoodTruckFinderWeb.Telemetry,
      FoodTruckFinder.Repo,
      {DNSCluster, query: Application.get_env(:food_truck_finder, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FoodTruckFinder.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FoodTruckFinder.Finch},
      # Start a worker by calling: FoodTruckFinder.Worker.start_link(arg)
      # {FoodTruckFinder.Worker, arg},
      # Start to serve requests, typically the last entry
      FoodTruckFinderWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FoodTruckFinder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FoodTruckFinderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
