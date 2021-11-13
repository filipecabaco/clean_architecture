defmodule CleanArchitecture.Domain.Model.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:email, :name, :inserted_at, :updated_at]}
  @type t :: %__MODULE__{
          email: String.t(),
          name: String.t(),
          password: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @primary_key {:uuid, Ecto.UUID, autogenerate: true}

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string, redact: true)
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, message: "Email already exists")
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true} = changeset) do
    {_, password} = fetch_field(changeset, :password)
    %{password_hash: password} = Argon2.add_hash(password)
    put_change(changeset, :password, password)
  end

  defp hash_password(%Ecto.Changeset{valid?: false} = changeset), do: changeset
end
