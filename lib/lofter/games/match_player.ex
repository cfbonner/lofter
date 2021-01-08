defmodule Lofter.Games.MatchPlayer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "match_players" do
    belongs_to :match, Lofter.Games.Match
    belongs_to :player, Lofter.Games.Player
    has_many :holes, Lofter.Games.Hole
    field :name, :string, default: "Woods"
    field :position, :integer

    timestamps()
  end

  def initial_changeset(match_player, attrs \\ %{}) do
    match_player
    |> cast(attrs, [:position])
    |> cast_assoc(
         :holes, with: &Lofter.Games.Hole.initial_changeset/2
       )
    |> validate_required([:position])
  end
end
