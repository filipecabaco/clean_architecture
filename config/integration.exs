import Config
import_config "test.exs"

config :clean_architecture, :database_child_spec, {CleanArchitecture.Adapter.Database.Postgres, []}
config :clean_architecture, :user_database, CleanArchitecture.Adapter.Database.Postgres.User

config :clean_architecture,
  ecto_repos: [CleanArchitecture.Adapter.Database.Postgres]

config :clean_architecture, CleanArchitecture.Adapter.Database.Postgres, pool: Ecto.Adapters.SQL.Sandbox
