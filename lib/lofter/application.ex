defmodule Lofter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Lofter.Repo,
      # Start the Telemetry supervisor
      LofterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Lofter.PubSub},
      # Start the Endpoint (http/https)
      LofterWeb.Endpoint
      # Start a worker by calling: Lofter.Worker.start_link(arg)
      # {Lofter.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lofter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LofterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
