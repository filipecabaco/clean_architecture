defmodule CleanArchitecture.Adapter.Entrypoint.Web.UserHandler do
  @moduledoc false
  alias CleanArchitecture.Domain.Service.{CreateUser, DeleteUser, ListUsers}
  import Plug.Conn
  @spec create(Plug.Conn.t()) :: Plug.Conn.t()
  def create(%{body_params: params} = conn), do: handle_result(conn, CreateUser.call(params))
  def create(conn), do: send_resp(conn, 400, "")

  @spec delete(Plug.Conn.t()) :: Plug.Conn.t()
  def delete(%{params: %{"email" => email}} = conn), do: handle_result(conn, DeleteUser.call(email))
  def delete(conn), do: send_resp(conn, 400, "")

  @spec list(Plug.Conn.t()) :: Plug.Conn.t()
  def list(conn), do: send_resp(conn, 200, Jason.encode_to_iodata!(ListUsers.call()))

  defp handle_result(conn, res) do
    case res do
      {:ok, res} ->
        send_resp(conn, 200, Jason.encode!(res))

      {:error, %Ecto.Changeset{} = changeset} ->
        handle_changeset_errors(conn, changeset)

      {:error, :resource_not_found} ->
        send_resp(conn, 404, "")

      _ ->
        send_resp(conn, 500, "")
    end
  end

  defp handle_changeset_errors(conn, %Ecto.Changeset{errors: errors}) do
    case(filter_conflict_messages(errors)) do
      [] ->
        send_resp(conn, 400, errors_to_json(errors))

      errors ->
        send_resp(conn, 409, errors_to_json(errors))
    end
  end

  defp filter_conflict_messages(errors) do
    Enum.filter(errors, fn {_, {_, constraints}} -> Keyword.take(constraints, [:constraint]) == :unique end)
  end

  defp errors_to_json(errors), do: errors |> Enum.map(&error_to_string/1) |> Jason.encode_to_iodata!()
  defp error_to_string({field, {message, _}}), do: "#{field}: #{message}"
end
