defmodule CleanArchitecture.Adapter.Entrypoint.Web do
  @moduledoc false
  use Plug.Router
  alias CleanArchitecture.Adapter.Entrypoint.Web.UserHandler

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get("/users", do: UserHandler.list(conn))
  post("/users", do: UserHandler.create(conn))
  delete("/users", do: UserHandler.delete(conn))

  match(_, do: send_resp(conn, 404, "oops"))
end
