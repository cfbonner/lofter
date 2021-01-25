defmodule Lofter.Clubhouse do
  @moduledoc """
  The Clubhouse context.
  """

  alias Lofter.Repo
  alias Lofter.Games.{Match, MatchPlayer}

  def all_user_matches(%{id: user_id} = user) do
    Match.all_user_matches(user_id)
  end
  def all_user_matches(_), do: [%Match{}]
end
