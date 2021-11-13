defmodule CleanArchitecture.Domain.Service.ListUsers do
  @moduledoc false
  alias CleanArchitecture.Adapter.Database.Postgres.User
  alias CleanArchitecture.Domain.Model.User, as: UserModel
  @user_database Application.compile_env(:clean_architecture, :user_database, User)

  @spec call() :: list(UserModel.t())
  def call, do: @user_database.list_users()
end
