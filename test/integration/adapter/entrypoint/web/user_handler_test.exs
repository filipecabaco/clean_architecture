defmodule CleanArchitecture.Adapter.Entrypoint.Web.UserHandlerTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CleanArchitecture.Adapter.Database.Postgres)
  end

  @tag :integration
  describe "post user" do
    test "creates a new user" do
      body = Jason.encode!(%{name: "name", email: "#{Ecto.UUID.generate()}@email.com", password: "password"})

      res = HTTPoison.post!("http://localhost:4000/users", body, [{"Content-Type", "application/json"}])
      assert 200 == res.status_code
    end

    test "error on repeated user" do
      body = Jason.encode!(%{name: "name", email: "#{Ecto.UUID.generate()}@email.com", password: "password"})

      HTTPoison.post!("http://localhost:4000/users", body, [{"Content-Type", "application/json"}])
      res = HTTPoison.post!("http://localhost:4000/users", body, [{"Content-Type", "application/json"}])

      assert 400 == res.status_code
    end
  end

  @tag :integration
  describe "delete user" do
    test "delete existing user returns success" do
      email = "#{Ecto.UUID.generate()}@email.com"
      body = Jason.encode!(%{name: "name", email: email, password: "password"})
      HTTPoison.post!("http://localhost:4000/users", body, [{"Content-Type", "application/json"}])
      res = HTTPoison.delete!("http://localhost:4000/users", [], params: [email: email])

      assert 200 == res.status_code
    end

    test "delete non-existing user returns success" do
      email = "#{Ecto.UUID.generate()}@email.com"
      res = HTTPoison.delete!("http://localhost:4000/users", [], params: [email: email])

      assert 200 == res.status_code
    end
  end

  @tag :integration
  describe "get user" do
    test "lists users" do
      body = Jason.encode!(%{name: "name", email: "#{Ecto.UUID.generate()}@email.com", password: "password"})
      HTTPoison.post!("http://localhost:4000/users", body, [{"Content-Type", "application/json"}])
      res = HTTPoison.get!("http://localhost:4000/users")

      assert 200 == res.status_code
      res_body = hd(Jason.decode!(res.body))
      assert res_body["name"]
      assert res_body["email"]
    end
  end
end
