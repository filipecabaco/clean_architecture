defmodule CleanArchitecture.Adapter.Database.Postgres.UserTest do
  use ExUnit.Case
  alias CleanArchitecture.Adapter.Database.Postgres.User
  alias CleanArchitecture.Domain.Model.User, as: UserModel

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CleanArchitecture.Adapter.Database.Postgres)
  end

  @tag :integration
  describe "create_user/1" do
    test "creates new user" do
      params = %{email: "email@email.com", name: "name", password: "password"}
      User.create_user(params)
      [user] = CleanArchitecture.Adapter.Database.Postgres.all(UserModel)

      assert user.email == params.email
      assert user.name == params.name
    end

    test "error on repeated user" do
      params = %{email: "email@email.com", name: "name", password: "password"}
      User.create_user(params)
      assert {:error, %{errors: errors, valid?: valid}} = User.create_user(params)
      refute valid
      assert errors == [email: {"Email already exists", [constraint: :unique, constraint_name: "users_email_index"]}]
    end
  end

  @tag :integration
  describe "delete_user/1" do
    test "deletes existing user by email" do
      params = %{email: "email@email.com", name: "name", password: "password"}
      User.create_user(params)
      User.delete_user(params.email)

      assert [] == CleanArchitecture.Adapter.Database.Postgres.all(UserModel)
    end

    test "error on non-existing  email" do
      assert {:error, :resource_not_found} == User.delete_user("no@email.com")
    end
  end

  @tag :integration
  describe "list_users/0" do
    test "list all users" do
      {:ok, user} = User.create_user(%{email: "email@email.com", name: "name", password: "password"})

      assert [res] = User.list_users()
      assert res.email == user.email
      assert res.name == user.name
    end

    test "empty list on no users" do
      assert [] == User.list_users()
    end
  end
end
