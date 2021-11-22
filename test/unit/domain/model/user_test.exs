defmodule CleanArchitecture.Domain.Model.UserTest do
  use ExUnit.Case, async: true
  alias CleanArchitecture.Domain.Model.User

  describe "changeset/2" do
    test "invalid changes if name is missing" do
      changeset = User.changeset(%User{}, %{email: "email@email.com", password: "password"})
      refute changeset.valid?
      assert changeset.errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "invalid changes if email is missing" do
      changeset = User.changeset(%User{}, %{name: "name", password: "password"})
      refute changeset.valid?
      assert changeset.errors == [email: {"can't be blank", [validation: :required]}]
    end

    test "invalid changes if password is missing" do
      changeset = User.changeset(%User{}, %{email: "email@email.com", name: "name"})
      refute changeset.valid?
      assert changeset.errors == [password: {"can't be blank", [validation: :required]}]
    end

    test "invalid emails returns invalid changes" do
      changeset = User.changeset(%User{}, %{email: "email", name: "potato", password: "password"})
      refute changeset.valid?
      assert changeset.errors == [email: {"has invalid format", [validation: :format]}]
    end

    test "password is hashed in change" do
      password = "password"
      changeset = User.changeset(%User{}, %{email: "email@email.com", name: "potato", password: "password"})
      refute changeset.changes.password == password
    end
  end
end
