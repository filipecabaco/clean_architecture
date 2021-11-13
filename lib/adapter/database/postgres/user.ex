defmodule CleanArchitecture.Adapter.Database.Postgres.User do
  @moduledoc false
  @behaviour CleanArchitecture.Port.Database.User

  alias CleanArchitecture.Adapter.Database.Postgres
  alias CleanArchitecture.Domain.Model.User

  import Ecto.Query

  @impl true
  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Postgres.insert()
  end

  @impl true
  def delete_user(email) do
    query = from(user in User, where: user.email == ^email)

    case Postgres.one(query) do
      nil -> {:error, :resource_not_found}
      user -> Postgres.delete(user)
    end
  end

  @impl true
  def list_users, do: Postgres.all(User)
end
