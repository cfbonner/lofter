defmodule Lofter.Games.Player do
  use Ecto.Schema

  schema "users" do
    has_many :match_players, Lofter.Games.MatchPlayer

    timestamps()
  end
end
