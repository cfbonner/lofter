defmodule Lofter.Games.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    has_many :match_players, Lofter.Games.MatchPlayer
    field :course, :string
    field :length, :integer
    field :player_ids, {:array, :string}, virtual: true

    timestamps()
  end

  def settings_changeset(match, attrs) do
    match
    |> cast(attrs, [:course, :length, :player_ids])
    |> validate_required([:course, :length, :player_ids])
  end

  def build_players_and_holes(%{valid?: false} = changeset), do: changeset
  def build_players_and_holes(match) do
    match
    |> cast(%{"match_players" => generate_match_players(match.changes.player_ids, match.changes.length)}, [])
    |> cast_assoc(
      :match_players,
      with: &Lofter.Games.MatchPlayer.initial_changeset/2
    )
  end

  defp generate_match_players(player_ids, hole_count) do
    Enum.with_index(player_ids)
    |> Enum.map(fn {user_id, position} ->
      %{
        user_id: user_id, 
        position: position, 
        holes: Enum.map(1..hole_count, &(%{position: &1}))
      }
    end)
  end
end
