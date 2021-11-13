defmodule CleanArchitecture.Adapter.Database.Memory.User do
  @behaviour CleanArchitecture.Port.Database.User

  alias CleanArchitecture.Domain.Model.User
  alias CleanArchitecture.Adapter.Database.Memory

  @impl true
  def create_user(name, email, password) do
    %User{}
    |> User.changeset(%{name: name, email: email, password: password})
    |> Memory.insert(User)
  end

  @impl true
  def delete_user(email) do
    with {:ok, user} <- Memory.one(&(&1.email == email), User) do
      Memory.delete(user, User)
    end
  end

  @impl true
  def list_users(), do: Memory.all(User)
end
