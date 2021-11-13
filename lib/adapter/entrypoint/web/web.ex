defmodule CleanArchitecture.Adapter.Entrypoint.Web do
  use Plug.Router
  alias CleanArchitecture.Adapter.Entrypoint.Web.UserHandler

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/users" do
    send_resp(conn, 200, Jason.encode_to_iodata!(UserHandler.list()))
  end

  post "/users" do
    case UserHandler.create(conn.body_params) do
      {:ok, res} ->
        send_resp(conn, 200, Jason.encode!(res))

      {:error, %{errors: errors}} ->
        errors = Enum.map(errors, fn {field, {message, _}} -> "#{field}: #{message}" end)
        send_resp(conn, 400, Jason.encode_to_iodata!(errors))
    end
  end

  delete "/users" do
    case UserHandler.delete(conn.params) do
      :ok ->
        send_resp(conn, 204, "")

      {:error, %{errors: errors}} ->
        errors = Enum.map(errors, fn {field, {message, _}} -> "#{field}: #{message}" end)
        send_resp(conn, 400, Jason.encode_to_iodata!(errors))
    end
  end

  match(_, do: send_resp(conn, 404, "oops"))
end
