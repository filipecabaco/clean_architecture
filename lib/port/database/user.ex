defmodule CleanArchitecture.Port.Database.User do
  alias CleanArchitecture.Domain.Model.User

  @callback create_user(name :: String.t(), email :: String.t(), password :: String.t()) ::
              {:ok, User.t()} | {:error, atom()}
  @callback list_users() :: list(User.t())
  @callback delete_user(email :: String.t()) :: :ok | {:error, atom()}
end
