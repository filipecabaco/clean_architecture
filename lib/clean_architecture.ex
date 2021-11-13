defmodule CleanArchitecture do
  @moduledoc false

  use Application
  require Logger
  alias CleanArchitecture.Adapter.Database.Postgres
  @database_child_spec Application.compile_env(:clean_architecture, :database_child_spec, Postgres)

  def start(_type, _args) do
    children = [
      @database_child_spec,
      {Plug.Cowboy, scheme: :http, plug: CleanArchitecture.Adapter.Entrypoint.Web, port: 4000}
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Logger.info(%{action: :server_started})
    Supervisor.start_link(children, opts)
  end
end
