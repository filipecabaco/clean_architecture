defmodule CleanArchitecture do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {CleanArchitecture.Adapter.Database.Memory, []},
      {CleanArchitecture.Adapter.Database.Postgres, []},
      {Plug.Cowboy, scheme: :http, plug: CleanArchitecture.Adapter.Entrypoint.Web, port: 4000}
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Logger.info(%{action: :server_started})
    Supervisor.start_link(children, opts)
  end
end
