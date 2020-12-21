defmodule Lofter.Games.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    has_many :holes, Lofter.Games.Hole
    field :course, :string
    field :length, :integer

    timestamps()
  end

  def settings_changeset(match, attrs) do
    match
    |> cast(attrs, [:course, :length])
    |> validate_required([:course, :length])
  end
end
