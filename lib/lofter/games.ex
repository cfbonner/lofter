defmodule Lofter.Games do
  @moduledoc """
  The Games context.
  """

  alias Lofter.Repo
  alias Lofter.Games.Match

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
    |> Repo.preload(:holes)
  end
end
