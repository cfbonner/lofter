defmodule Lofter.Games.Hole do
  use Ecto.Schema

  schema "holes" do
    belongs_to :match, Lofter.Games.Match
    field :par, :integer
    field :strokes, :integer

    timestamps()
  end
end
