defmodule CleanArchitecture.Domain.Service.DeleteUser do
  @moduledoc false
  alias CleanArchitecture.Adapter.Database.Postgres.User
  @user_database Application.compile_env(:clean_architecture, :user_database, User)

  @spec call(String.t()) :: :ok | {:error, atom()}
  def call(email), do: @user_database.delete_user(email)
end
