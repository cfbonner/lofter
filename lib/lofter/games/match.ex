defmodule Lofter.Games.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    has_many :match_players, Lofter.Games.MatchPlayer
    field :course, :string
    field :length, :integer

    timestamps()
  end

  def settings_changeset(match, attrs) do
    match
    |> cast(attrs, [:course, :length])
    |> validate_required([:course, :length])
  end


  def build_players_and_holes(match, player_count, hole_count) do
    match
    |> cast(%{"match_players" => generate_players(player_count, hole_count)}, [])
    |> cast_assoc(
         :match_players, with: &Lofter.Games.MatchPlayer.initial_changeset/2
       )
  end

  defp generate_players(player_count, hole_count) do
    case Integer.parse(player_count) do
      {amount, _} ->
        Enum.map(
          1..amount, fn n -> %{position: n, holes: generate_holes(hole_count)} end
        )
      :error -> %{}
    end
  end

  defp generate_holes(hole_count) do
    case Integer.parse(hole_count) do
      {amount, _} ->
        Enum.map(1..amount, fn n -> %{position: n} end)
      :error -> %{}
    end
  end
end
