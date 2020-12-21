defmodule LofterWeb.Router do
  use LofterWeb, :router

  import LofterWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LofterWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LofterWeb do
    pipe_through :browser

    get "/", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LofterWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LofterWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", LofterWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/user/register", UserRegistrationController, :new
    post "/user/register", UserRegistrationController, :create
    get "/user/log_in", UserSessionController, :new
    post "/user/log_in", UserSessionController, :create
    get "/user/reset_password", UserResetPasswordController, :new
    post "/user/reset_password", UserResetPasswordController, :create
    get "/user/reset_password/:token", UserResetPasswordController, :edit
    put "/user/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", LofterWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/game/new", GameSettingsController, :new
    post "/game/create", GameSettingsController, :create
    get "/game/edit", GameController, :edit

    get "/user/settings", UserSettingsController, :edit
    put "/user/settings", UserSettingsController, :update
    get "/user/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", LofterWeb do
    pipe_through [:browser]

    delete "/user/log_out", UserSessionController, :delete
    get "/user/confirm", UserConfirmationController, :new
    post "/user/confirm", UserConfirmationController, :create
    get "/user/confirm/:token", UserConfirmationController, :confirm
  end
end
