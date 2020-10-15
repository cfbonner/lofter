defmodule Lofter.Repo do
  use Ecto.Repo,
    otp_app: :lofter,
    adapter: Ecto.Adapters.Postgres
end
