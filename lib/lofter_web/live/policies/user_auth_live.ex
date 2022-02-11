defmodule LofterWeb.UserLiveAuth do
  import Phoenix.LiveView

  def on_mount(:default, _params, %{"user_token" => token}, socket) do
    if current_user = Lofter.Accounts.get_user_by_session_token(token) do
      socket =
        assign_new(socket, :current_user, fn ->
          current_user
        end)

      {:cont, socket}
    else
      {:halt, socket}
    end
  end
end
