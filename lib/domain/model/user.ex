defmodule CleanArchitecture.Domain.Model.User do
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
  end
end
