defmodule CleanArchitecture.Adapter.Postgres.Migrations.AddUsers do
  use Ecto.Migration

  def up do
    create table("users") do
      add(:uuid, :binary)
      add(:email, :string)
      add(:name, :string)
      add(:password, :string)

      timestamps()
    end
  end

  def down do
    drop(table("users"))
  end
end
