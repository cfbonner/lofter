defmodule Lofter.Games do
  @moduledoc """
  The Games context.
  """

  alias Lofter.Repo
  alias Lofter.Games.{Match, MatchPlayer, Hole}

  def setup_match(%Match{} = match, attrs \\ %{}) do
    Match.settings_changeset(match, attrs)
  end

  def start_match(attrs \\ %{}) do
    %Match{}
    |> Match.settings_changeset(attrs)
    |> Match.build_players_and_holes()
    |> Repo.insert()
  end

  def get_match!(id) do
    Match
    |> Repo.get(id)
    |> Repo.preload(match_players: MatchPlayer.order_by_position_query())
  end

  def update_match(match_id, hole_id, hole_strokes) do
    attrs = %{strokes: hole_strokes}

    Hole
    |> Repo.get(hole_id)
    |> Hole.strokes_changeset(attrs)
    |> Repo.update()

    get_match!(match_id)
  end

  def get_match_player!(match_players, match_player_id) do
    case Integer.parse(match_player_id) do
      {id, _} ->
        [match_player | _rest] = Enum.filter(match_players, fn m -> m.id == id end)
        match_player

      :error ->
        List.first(match_players)
    end
  end

  def update_match_player(match_player, attrs) do
    match_player
    |> MatchPlayer.changeset(attrs)
    |> Repo.update()
  end

  def next_hole!(game_id, current_hole_position, holes_count) do
    next =
      Integer.mod(
        current_hole_position + 1,
        holes_count
      )

    next_hole_position =
      case next do
        0 -> holes_count
        _ -> next
      end

    Repo.one(Hole.find_by_position_query(game_id, next_hole_position))
  end

  def prev_hole!(game_id, current_hole_position, holes_count) do
    next_hole_position =
      if current_hole_position - 1 == 0 do
        holes_count
      else
        current_hole_position - 1
      end

    Repo.one(Hole.find_by_position_query(game_id, next_hole_position))
  end

  def get_hole!(id) do
    Hole
    |> Repo.get(id)
  end

  def add_hole!(match) do
    position = match.length + 1

    match
    |> Match.settings_changeset(%{length: position})
    |> Repo.update()

    match
    |> Ecto.build_assoc(:holes, %{par: 3, position: position})
    |> Repo.insert()
  end
end
