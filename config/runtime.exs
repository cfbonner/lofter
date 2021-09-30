# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """

config :lofter, LogLady.Repo,
  adapter: Ecto.Adapters.Postgres,
  show_sensitive_data_on_connection_error: true,
  username: "postgres",
  password: "postgres",
  hostname: "lofter-db",
  database: "lofter_prod",  
  # ssl: true,
  # url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  'e3jq9sL6MoG1ls3DE9tXWEAzMLe/BJGl3KyU6uchKFMNM/NBOxbqPIvHmhYBA886'

config :lofter, LogLadyWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :lofter, LogLadyWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

