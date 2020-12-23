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

  def build_holes(match, length) do
    {amount, _} = Integer.parse(length)
    holes_attrs = %{ "holes" => generate_holes([], amount) }

    match
    |> cast(holes_attrs, [])
    |> cast_assoc(:holes, with: &Lofter.Games.Hole.initial_changeset/2)
  end

  defp generate_holes(holes, 0) do
    holes
  end
  defp generate_holes(holes, amount) do
    generate_holes([%{position: amount} | holes], amount - 1)
  end
end
