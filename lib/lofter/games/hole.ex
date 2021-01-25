defmodule Lofter.Games.Hole do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "holes" do
    belongs_to :match_player, Lofter.Games.MatchPlayer
    field :par, :integer, default: 3
    field :strokes, :integer, default: 0
    field :position, :integer

    timestamps()
  end

  def initial_changeset(hole, attrs \\ %{}) do
    hole
    |> cast(attrs, [:position])
    |> validate_required([:position])
  end

  def strokes_changeset(hole, attrs \\ %{}) do
    hole
    |> cast(attrs, [:strokes])
    |> validate_required([:strokes])
  end

  def order_by_position_query do
    from h in __MODULE__,
      order_by: h.position
  end

  def find_by_position_query(match_player_id, position) do
    from h in __MODULE__,
      where: h.match_player_id == ^match_player_id and h.position == ^position
  end
end
