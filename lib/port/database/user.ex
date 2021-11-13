defmodule CleanArchitecture.Port.Database.User do
  @moduledoc false
  alias CleanArchitecture.Domain.Model.User

  @callback create_user(map()) :: {:ok, User.t()} | {:error, any()}
  @callback list_users() :: list(User.t())
  @callback delete_user(email :: String.t()) :: :ok | {:error, any()}
end
