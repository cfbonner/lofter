defmodule Lofter.Friendships do
  @moduledoc """
  The Friendships context.
  """

  import Ecto.Query, warn: false
  alias Lofter.Repo

  alias Lofter.Accounts.User
  alias Lofter.Friendships.Friendship

  @doc """
  Returns the list of users friendships.

  ## Examples

      iex> get_users_friends(%User{})
      [%User{}, ...]

  """
  def get_users_friends(user = %User{}, status \\ :confirmed) do
    Repo.all(
      from friend in User,
        join: fs in Friendship,
        on: fs.user_id == ^user.id or fs.friend_id == ^user.id,
        where:
          fs.status == ^status and friend.id != ^user.id and
            (fs.user_id == friend.id or fs.friend_id == friend.id),
        select_merge: %{friendship: fs},
        limit: 50
    )
  end

  def get_users_friend(user = %User{}, friend = %User{}, status \\ :confirmed) do
    Repo.one(
      from friend in User,
        join: fs in Friendship,
        on: fs.user_id == ^user.id or fs.friend_id == ^user.id,
        where:
          fs.status == ^status and friend.id != ^user.id and
            (fs.user_id == friend.id or fs.friend_id == friend.id),
        select_merge: %{friendship: fs}
    )
  end

  def request_friendship(%User{id: user_id}, %User{id: friend_id}),
    do: update_friend_status(:pending, %User{id: user_id}, %User{id: friend_id})

  def confirm_friendship(%User{id: user_id}, %User{id: friend_id}),
    do: update_friend_status(:confirmed, %User{id: user_id}, %User{id: friend_id})

  def unfriend_friendship(%User{id: user_id}, %User{id: friend_id}),
    do: update_friend_status(:unfriended, %User{id: user_id}, %User{id: friend_id})

  def reject_friendship(%User{id: user_id}, %User{id: friend_id}),
    do: update_friend_status(:rejected, %User{id: user_id}, %User{id: friend_id})

  defp update_friend_status(status, %User{id: user_id}, %User{id: friend_id}) do
    attrs = %{status: status, last_actioned_by: user_id}

    case Repo.one(Friendship.users_friendship(user_id, friend_id, :any)) do
      nil ->
        %Friendship{user_id: user_id, friend_id: friend_id}
        |> Friendship.changeset(attrs)
        |> Repo.insert()

      record ->
        record
        |> Friendship.changeset(attrs)
        |> Repo.update()
    end
  end
end
