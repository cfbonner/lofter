defmodule Lofter.Games.Hole do
  use Ecto.Schema
  import Ecto.Changeset

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
end
