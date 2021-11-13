defmodule CleanArchitecture.Adapter.Postgres.Migrations.AddIndexUserEmail do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email])
  end
end
