defmodule CleanArchitecture.Adapter.Entrypoint.Web.UserHandler do
  alias CleanArchitecture.Domain.Model.User
  alias CleanArchitecture.Domain.Service.{CreateUser, DeleteUser, ListUsers}
  @spec create(map()) :: {:ok, User.t()} | {:error, atom()}
  def create(%{"name" => name, "email" => email, "password" => password}), do: CreateUser.call(name, email, password)

  @spec delete(map) :: :ok
  def delete(%{"email" => email}), do: DeleteUser.call(email)

  @spec list() :: list(User.t())
  def list(), do: ListUsers.call()
end
