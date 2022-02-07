defmodule Lofter.Friendships.Friendship do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "friendships" do
    belongs_to :user, Lofter.Accounts.User
    belongs_to :friend, Lofter.Accounts.User
    field :status, Ecto.Enum, values: [:pending, :confirmed, :rejected, :unfriended]
    field :last_actioned_by, :integer
    timestamps()
  end

  @doc false
  def changeset(friendship, attrs) do
    friendship
    |> cast(attrs, [:user_id, :friend_id, :status, :last_actioned_by])
    |> validate_required([:status, :last_actioned_by])
    |> unique_constraint(
      [:user_id, :friend_id],
      name: :friendships_user_id_friend_id_index
    )
    |> unique_constraint(
      [:friend_id, :user_id],
      name: :friendships_friend_id_user_id_index
    )
  end

  def users_friendship(user_id, friend_id, :any) do
    from friendship in __MODULE__,
      where:
        (friendship.user_id == ^user_id and friendship.friend_id == ^friend_id) or
          (friendship.user_id == ^friend_id and friendship.friend_id == ^user_id)
  end

  def users_friendship(user_id, friend_id) do
    from friendship in __MODULE__,
      where:
        ((friendship.user_id == ^user_id and friendship.friend_id == ^friend_id) or
           (friendship.user_id == ^friend_id and friendship.friend_id == ^user_id)) and
          friendship.status == :confirmed
  end

  def users_friendship_request(user_id, friend_id) do
    from friendship in __MODULE__,
      where:
        ((friendship.user_id == ^user_id and friendship.friend_id == ^friend_id) or
           (friendship.user_id == ^friend_id and friendship.friend_id == ^user_id)) and
          friendship.status == :pending
  end
end
