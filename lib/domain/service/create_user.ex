defmodule CleanArchitecture.Domain.Service.CreateUser do
  alias CleanArchitecture.Adapter.Database.Postgres.User
  alias CleanArchitecture.Domain.Model.User, as: UserModel
  @user_database Application.get_env(:clean_architecture, :user_database, User)

  @spec call(String.t(), String.t(), String.t()) :: {:ok, UserModel.t()} | {:error, atom()}
  def call(name, email, password) do
    %{password_hash: password} = Argon2.add_hash(password)
    @user_database.create_user(name, email, password)
  end
end
