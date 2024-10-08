# FoodTruckFinder

This app helps you find food trucks and food carts near your office for your lunch break. Just enter your office address, and all options that hold a valid permit from the city within 1.5km will be displayed. You can click on the dots to find the name and address of each option.

## Setup

### Dependencies

This application depends on [PostgreSQL](https://www.postgresql.org/) and the extension [PostGIS](https://postgis.net/). On Mac OSX, you can install this with:

```bash
brew install postgres postgis
```

It's built with [Elixir](http://elixirlang.org/), [Phoenix](https://www.phoenixframework.org/), and Leaflet (via `npm`). The repo includes a `.tool-versions` file for [asdf](https://asdf-vm.com/) with the Elixir and NodeJS versions.

Install JS dependencies:

```bash
cd assets/vendor
npm install
```

Configure the database credentials in config files found under`config/` then load the data from CSV, setting the path to the file in the `CSV_PATH` environment variable

Install Elixir dependencies and read in data

```bash
CSV_PATH="/home/me/Downloads/Mobile_Food_Facility_Permit.csv" mix setup
```

### Run it

```bash
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Decisions

For such a small data set, I could've used SQLite, but I liked the idea of learning about PostGIS, and the "Post" stands for "PostgreSQL".

The database setup assumes that in production a cron job or similar can pull updates to the CSV and reload it (using the environment variable and `mix ecto.reset`). This is not data that changes minute-by-minute or second-by-second. Periodic data refreshes are sufficient. I included the location ID despite no intention of displaying it in case it could be useful for updating entries if that's preferred over drop-and-rebuild.

Facilities without valid permits are excluded from the data set because the alternative sounds disappointing when the food truck isn't there.

1.5km was chosen because the average lunch break is no more than 1 hour, and you want time to walk over, get your food, walk back, and eat. (It was going to be 1km, but having between 0 and 2 results was too common.)

I removed some Phoenix boiler plate, but I left things like the `PageController` in on the basis that such a site could conceivably have informational or other background pages besides the main map page, and leaving that in place would future-proof.

### Missing stuff

I wanted to include the option to filter by what kind of things they sell, but I didn't get to it. Besides, the density of options isn't high enough to really do much filtering within the chosen walking distance of 1.5km.

Tests. Testing `FoodTruckFinder.Map.get_facilities/2` would've required calculating a data set where we know which points are or aren't within the 1.5km radius and setting up a separate test database. Testing the UI would've involved a headless browser setup and something like mocha. Neither of those are fast types of tests to write. So, I only added the doctests necessary to test the util function I added for pulling float values out of maps that look like `%{"key" => "1.5"}`.

I thought about deploying this to Fly.io for you to play with, but they no longer have a free tier as of 24 hours ago.

### Lessons learned

I decided to do this particular project with the data in order to learn a bunch of new stuff, like PostGIS, LiveView, and OpenStreetMap. In the process, I learned that the postgis plugin for `asdf` is unmaintained and broken and that the Elixir Language Server sometimes crashes in ways that prevent VS Code from writing to disk. I also sent a patch to the LiveView project to correct the documentation, which was both missing crucial information and outdated. (Yes, [PR submitted and merged](https://github.com/phoenixframework/phoenix_live_view/pull/3457).)

"Don't try something new during a test" is going on the list of "lessons learned." Broken tooling and incorrect documentation were major impediments.

### Directory

- The database table is defined in `priv/repo/migrations` and `lib/food_truck_finder/facility.ex`
- The database is populated by `priv/repo/seeds.exs` which is automatically run by the `mix setup` task
- The map is populated by `lib/food_truck_finder_web/live/map_live.ex` which calls into `lib/food_truck_finder/map.ex` to get map points and relays its results to `assets/js/app.js`
