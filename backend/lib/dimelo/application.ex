defmodule Dimelo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # verify env vars are not missing
    Dimelo.Services.OpenAI.token()

    children = [
      # Start the Ecto repository
      Dimelo.Repo,
      # Start the Telemetry supervisor
      DimeloWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dimelo.PubSub},
      # Start the Endpoint (http/https)
      DimeloWeb.Endpoint
      # Start a worker by calling: Dimelo.Worker.start_link(arg)
      # {Dimelo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dimelo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DimeloWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
