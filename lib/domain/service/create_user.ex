defmodule CleanArchitecture.Domain.Service.CreateUser do
  @moduledoc false
  alias CleanArchitecture.Adapter.Database.Postgres.User
  alias CleanArchitecture.Domain.Model.User, as: UserModel
  @user_database Application.compile_env(:clean_architecture, :user_database, User)

  @spec call(map()) :: {:ok, UserModel.t()} | {:error, atom() | list()}
  def call(params), do: @user_database.create_user(params)
end
