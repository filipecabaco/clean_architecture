defmodule CleanArchitecture.Adapter.Database.Memory.User do
  @moduledoc false
  @behaviour CleanArchitecture.Port.Database.User

  alias CleanArchitecture.Adapter.Database.Memory
  alias CleanArchitecture.Domain.Model.User

  @impl true
  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Memory.insert(User)
  end

  @impl true
  def delete_user(email) do
    with {:ok, user} <- Memory.one(&(&1.email == email), User) do
      Memory.delete(user, User)
    end
  end

  @impl true
  def list_users, do: Memory.all(User)
end
