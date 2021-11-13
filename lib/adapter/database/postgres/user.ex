defmodule CleanArchitecture.Adapter.Database.Postgres.User do
  @behaviour CleanArchitecture.Port.Database.User

  alias CleanArchitecture.Domain.Model.User
  alias CleanArchitecture.Adapter.Database.Postgres
  import Ecto.Query

  @impl true
  def create_user(name, email, password) do
    %User{}
    |> User.changeset(%{name: name, email: email, password: password})
    |> Postgres.insert()
  end

  @impl true
  def delete_user(email) do
    query = from(user in User, where: user.email == ^email)

    with user <- Postgres.one(query),
         {:ok, _} <- Postgres.delete(user) do
      :ok
    end
  end

  @impl true
  def list_users(), do: Postgres.all(User)
end
