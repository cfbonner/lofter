defmodule Lofter.Games.Hole do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "holes" do
    belongs_to :match, Lofter.Games.Match
    field :par, :integer, default: 3
    field :strokes, :integer
    field :position, :integer

    timestamps()
  end

  def initial_changeset(hole, attrs \\ %{}) do
    hole
    |> cast(attrs, [:position])
    |> validate_required([:position])
  end

  def position_query do
    from h in __MODULE__, order_by: h.position
  end
end
