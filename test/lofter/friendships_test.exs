defmodule Lofter.FriendshipsTest do
  use Lofter.DataCase

  import Lofter.AccountsFixtures

  alias Lofter.Friendships
  alias Lofter.Friendships.Friendship

  setup do
    user_one = user_fixture(%{email: "user1@email.com"})
    user_two = user_fixture(%{email: "user2@email.com"})
    {:ok, friendship} = Friendships.request_friendship(user_one, user_two)

    {:ok, user_one: user_one, user_two: user_two, friendship: friendship}
  end

  test "request_friendship/2", %{user_one: user_one, user_two: user_two, friendship: friendship} do
    assert friendship.user_id == user_one.id
    assert friendship.friend_id == user_two.id
    assert friendship.status == :pending
  end

  test "two become friends, stop being friends, the other asks to become friends again", %{
    user_one: user_one,
    user_two: user_two
  } do
    {:ok, friendship} = Friendships.confirm_friendship(user_two, user_one)
    assert friendship.status == :confirmed
    {:ok, friendship} = Friendships.unfriend_friendship(user_one, user_two)
    assert friendship.status == :unfriended
    {:ok, friendship} = Friendships.request_friendship(user_two, user_one)
    assert friendship.status == :pending
    assert Repo.one(Friendship.users_friendship(user_one.id, user_two.id, :any))
    {:ok, friendship} = Friendships.confirm_friendship(user_one, user_two)
    assert friendship.status == :confirmed

    assert Friendships.get_users_friends(user_two)
           |> Enum.any?(&(&1.id == user_one.id))

    assert Friendships.get_users_friends(user_one)
           |> Enum.any?(&(&1.id == user_two.id))
  end

  test "confirm_friendship/1", %{user_one: user_one, user_two: user_two} do
    refute user_one == List.first(Friendships.get_users_friends(user_two))
    refute user_two == List.first(Friendships.get_users_friends(user_one))

    {:ok, friendship} = Friendships.confirm_friendship(user_one, user_two)
    assert friendship.status == :confirmed

    assert Friendships.get_users_friends(user_two)
           |> Enum.any?(&(&1.id == user_one.id))

    assert Friendships.get_users_friends(user_one)
           |> Enum.any?(&(&1.id == user_two.id))
  end

  test "reject_friendship/1", %{user_one: user_one, user_two: user_two} do
    refute Friendships.get_users_friends(user_two)
           |> Enum.any?(&(&1.id == user_one.id))

    refute Friendships.get_users_friends(user_one)
           |> Enum.any?(&(&1.id == user_two.id))

    {:ok, _friendship} = Friendships.reject_friendship(user_one, user_two)

    refute Friendships.get_users_friends(user_two)
           |> Enum.any?(&(&1.id == user_one.id))

    refute Friendships.get_users_friends(user_one)
           |> Enum.any?(&(&1.id == user_two.id))
  end

  test "unfriend_friendship/1", %{user_one: user_one, user_two: user_two} do
    {:ok, friendship} = Friendships.confirm_friendship(user_one, user_two)
    assert friendship.status == :confirmed

    assert Friendships.get_users_friends(user_two)
           |> Enum.any?(&(&1.id == user_one.id))

    assert Friendships.get_users_friends(user_one)
           |> Enum.any?(&(&1.id == user_two.id))

    {:ok, _friendship} = Friendships.unfriend_friendship(user_one, user_two)

    refute Friendships.get_users_friends(user_two)
           |> Enum.any?(&(&1.id == user_one.id))

    refute Friendships.get_users_friends(user_one)
           |> Enum.any?(&(&1.id == user_two.id))
  end

  test "reversed unfriend_friendship/1", %{user_one: user_one, user_two: user_two} do
    {:ok, friendship} = Friendships.confirm_friendship(user_one, user_two)
    assert friendship.status == :confirmed

    assert Friendships.get_users_friends(user_two)
           |> Enum.any?(&(&1.id == user_one.id))

    assert Friendships.get_users_friends(user_one)
           |> Enum.any?(&(&1.id == user_two.id))

    {:ok, friendship} = Friendships.unfriend_friendship(user_two, user_one)

    assert friendship.status == :unfriended

    refute Friendships.get_users_friends(user_two)
           |> Enum.any?(&(&1.id == user_one.id))

    refute Friendships.get_users_friends(user_one)
           |> Enum.any?(&(&1.id == user_two.id))
  end
end
