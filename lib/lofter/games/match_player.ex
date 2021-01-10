defmodule Lofter.Games.MatchPlayer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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
      :holes,
      with: &Lofter.Games.Hole.initial_changeset/2
    )
    |> validate_required([:position])
  end

  def changeset(match_player, attrs \\ %{}) do
    match_player
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def order_by_position_query do
    from mp in __MODULE__,
      order_by: mp.position,
      preload: [holes: ^Lofter.Games.Hole.order_by_position_query()]
  end
end
