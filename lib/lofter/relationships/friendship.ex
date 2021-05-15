defmodule Lofter.Relationships.Friendship do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Lofter.Repo

  @primary_key false
  schema "friendships" do
    belongs_to :user, Lofter.Accounts.User
    belongs_to :friend, Lofter.Accounts.User
    field :status, Ecto.Enum, values: [:pending, :confirmed, :rejected]
    timestamps()
  end

  @doc false
  def changeset(friendship, attrs) do
    friendship
    |> cast(attrs, [:user_id, :friend_id, :status])
    |> validate_required([:status])
    |> unique_constraint(
      [:user_id, :friend_id],
      name: :friendships_user_id_friend_id_index
    )
    |> unique_constraint(
      [:friend_id, :user_id],
      name: :friendships_friend_id_user_id_index
    )
  end

  def user_friend_request(user_id, friend_id) do
    from friendship in __MODULE__,
      where:
        friendship.user_id == ^user_id and friendship.friend_id == ^friend_id and
          friendship.status == :pending
  end
end
