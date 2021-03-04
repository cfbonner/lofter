defmodule Lofter.Clubhouse do
  @moduledoc """
  The Clubhouse context.
  """

  alias Lofter.Games.Match

  def all_user_matches(%{id: user_id}) do
    Match.all_user_matches(user_id)
  end
  def all_user_matches(_), do: [%Match{}]
end
