defmodule LofterWeb.UserSummaryComponent do
  use Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <h2><%= @selected_user.email %></h2>
      <p><%= @selected_user.inserted_at %></p>
      <ul class="text-right">
        <li><a phx-click="request_friendship" phx-value-friend-id={@selected_user.id} href="#" class="text-green-600 hover:underline">Add friend</a></li>
      </ul>
    </div>
    """
  end
end

