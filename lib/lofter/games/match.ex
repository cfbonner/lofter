defmodule Lofter.Games.Match do
  use Ecto.Schema
  alias Lofter.Repo
  import Ecto.Changeset
  import Ecto.Query

  schema "matches" do
    has_many :match_players, Lofter.Games.MatchPlayer, on_delete: :delete_all
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

  def for_user_query(user_id) do
    from match in __MODULE__,
      order_by: match.updated_at,
      join: player in Lofter.Games.MatchPlayer,
      on: player.match_id == match.id,
      where: player.user_id == ^user_id,
      preload: [match_players: :holes]
  end

  def all_user_matches(user_id) do
    Repo.all(for_user_query(user_id))
  end
end
