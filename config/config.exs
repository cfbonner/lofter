# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :lofter,
  ecto_repos: [Lofter.Repo]

# Configures the endpoint
config :lofter, LofterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eqwNwAXspWGuL2E70xMqPRhf88Y6RPYtNN5JyIeN0tIQ1aNcuiYslzm/qqHOnshz",
  render_errors: [view: LofterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Lofter.PubSub,
  live_view: [signing_salt: "SYMd4CWa"]

config :esbuild,
  version: "0.12.26",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :lofter, Lofter.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
