defmodule Lofter.FriendshipsTest do
  use Lofter.DataCase

  import Lofter.AccountsFixtures

  alias Lofter.Friendships

  setup do
    user_one = user_fixture(%{email: "user1@email.com"})
    user_two = user_fixture(%{email: "user2@email.com"})
    {_, friendship} = Friendships.request_friendship(user_one, user_two)

    {:ok, user_one: user_one, user_two: user_two, friendship: friendship}
  end

  test "request_friendship/2", %{user_one: user_one, user_two: user_two, friendship: friendship} do
    assert friendship.user_id == user_one.id
    assert friendship.friend_id == user_two.id
    assert friendship.status == :pending
  end

  test "confirm_friendship/1", %{user_one: user_one, user_two: user_two} do
    refute user_one == List.first(Friendships.get_users_friends(user_two))
    refute user_two == List.first(Friendships.get_users_friends(user_one))

    {:ok, friendship} = Friendships.confirm_friendship(user_one, user_two)
    assert friendship.status == :confirmed

    assert user_one == List.first(Friendships.get_users_friends(user_two))
    assert user_two == List.first(Friendships.get_users_friends(user_one))
  end

  test "reject_friendship/1", %{user_one: user_one, user_two: user_two} do
    refute user_one == List.first(Friendships.get_users_friends(user_two))
    refute user_two == List.first(Friendships.get_users_friends(user_one))

    {:ok, _friendship} = Friendships.reject_friendship(user_one, user_two)

    refute user_one == List.first(Friendships.get_users_friends(user_two))
    refute user_two == List.first(Friendships.get_users_friends(user_one))
  end

  test "unfriend_friendship/1", %{user_one: user_one, user_two: user_two} do
    {:ok, friendship} = Friendships.confirm_friendship(user_one, user_two)
    assert friendship.status == :confirmed

    assert user_one == List.first(Friendships.get_users_friends(user_two))
    assert user_two == List.first(Friendships.get_users_friends(user_one))
    :ok = Friendships.unfriend_friendship(user_one, user_two)

    refute user_one == List.first(Friendships.get_users_friends(user_two))
    refute user_two == List.first(Friendships.get_users_friends(user_one))
  end

  test "reversed unfriend_friendship/1", %{user_one: user_one, user_two: user_two} do
    {:ok, friendship} = Friendships.confirm_friendship(user_one, user_two)
    assert friendship.status == :confirmed

    assert user_one == List.first(Friendships.get_users_friends(user_two))
    assert user_two == List.first(Friendships.get_users_friends(user_one))
    :ok = Friendships.unfriend_friendship(user_two, user_one)

    refute user_one == List.first(Friendships.get_users_friends(user_two))
    refute user_two == List.first(Friendships.get_users_friends(user_one))
  end
end
