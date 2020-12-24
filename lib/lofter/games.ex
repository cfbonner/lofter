defmodule Lofter.Games do
  @moduledoc """
  The Games context.
  """

  alias Lofter.Repo
  alias Lofter.Games.{Match, Hole}

  def setup_match(%Match{} = match, attrs \\ %{}) do
    Match.settings_changeset(match, attrs)
  end

  def start_match(attrs \\ %{}) do
    %Match{}
    |> Match.settings_changeset(attrs)
    |> Match.build_holes(attrs["length"])
    |> Repo.insert()
  end

  def get_match!(id) do
    Match
    |> Repo.get(id)
    |> Repo.preload(holes: Hole.position_query)
  end

  def update_match(match_id, hole_id, hole_strokes) do
    attrs = %{ strokes: hole_strokes }
    Hole
    |> Repo.get(hole_id)
    |> Hole.strokes_changeset(attrs)
    |> Repo.update()

    get_match!(match_id)
  end

  def get_hole!(id) do
    Hole
    |> Repo.get(id)
  end
end
