# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lofter,
  ecto_repos: [Lofter.Repo]

# Configures the endpoint
config :lofter, LofterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eqwNwAXspWGuL2E70xMqPRhf88Y6RPYtNN5JyIeN0tIQ1aNcuiYslzm/qqHOnshz",
  render_errors: [view: LofterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Lofter.PubSub,
  live_view: [signing_salt: "SYMd4CWa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
