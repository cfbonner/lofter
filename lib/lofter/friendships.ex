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
        select_merge: %{friend_requestor: fs.user_id},
        limit: 50
    )
  end

  @doc """
  Creates a 'pending' friendship

  ## Examples

      iex> request_friendship(%User{}, %User{})
      {:ok, %User{}}

  """
  def request_friendship(%User{id: user_id}, %User{id: friend_id}) do
    %Friendship{user_id: user_id, friend_id: friend_id}
    |> Friendship.changeset(%{status: :pending})
    |> Repo.insert()
  end

  @doc """
  Updates friendship status to 'confirmed'

  ## Examples

      iex> confirm_friendship(%User{}, %User{})
      {:ok, %Friendship{}}

  """
  def confirm_friendship(%User{id: user_id}, %User{id: friend_id}) do
    friendship = Friendship.users_friendship_request(user_id, friend_id)
    case Repo.update_all(friendship, set: [status: :confirmed]) do
      {1, nil} -> { :ok, Map.put(friendship, :status, :confirmed) }
      _ -> :error
    end
  end

  def reject_friendship(%User{id: user_id}, %User{id: friend_id}) do
    friendship = Friendship.users_friendship_request(user_id, friend_id)
    case Repo.delete_all(friendship) do
      {1, nil} -> { :ok, Map.put(friendship, :status, :rejected) }
      _ -> :error
    end
  end

  def unfriend_friendship(%User{id: user_id}, %User{id: friend_id}) do
    case Repo.delete_all(Friendship.users_friendship(user_id, friend_id)) do
      {1, nil} -> :ok
      _ -> :error
    end
  end
end
