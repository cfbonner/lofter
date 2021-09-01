defmodule LofterWeb.UserFriendsController do

  use LofterWeb, :controller

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    friends = Lofter.Relationships.get_users_friends(current_user)
    friend_requests = Lofter.Relationships.get_users_friends(current_user, :pending)

    render(conn, "index.html", friends: friends, friend_requests: friend_requests)
  end

  def update(conn, %{"id" => id, "status" => confirm}, current_user) do
    friend = Lofter.Accounts.get_user!(id)

    message = case Lofter.Relationships.confirm_friendship(current_user, friend) do
                {:ok, confirmed} -> 
                  [:info, "Confirmed!"]
                _ -> 
                  [:error, "Nope!"]
              end

    friends = Lofter.Relationships.get_users_friends(current_user)
    friend_requests = Lofter.Relationships.get_users_friends(current_user, :pending)

    
    conn
    |> put_flash(:info, 'this')    
    |> render("index.html", friends: friends, friend_requests: friend_requests)
  end
end
