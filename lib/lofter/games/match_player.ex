defmodule Lofter.Games.MatchPlayer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "match_players" do
    belongs_to :match, Lofter.Games.Match
    belongs_to :user, Lofter.Accounts.User, foreign_key: :user_id
    has_many :holes, Lofter.Games.Hole, on_delete: :delete_all
    field :name, :string, default: "Woods"
    field :position, :integer

    timestamps()
  end

  def initial_changeset(match_player, attrs \\ %{}) do
    attrs_with_name = Map.put(attrs, :name, random_name())

    match_player
    |> cast(attrs_with_name, [:position, :user_id, :name])
    |> validate_required([:position])
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

  def random_name do
    Enum.random(sample_names)
  end

  def sample_names do
    ~w(
      Nelson Watson Palmer Jones Snead Player
      Hagen Hogan Woods Nicklaus
    )
  end
end
