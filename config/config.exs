import Config

config :clean_architecture, :user_database, CleanArchitecture.Adapter.Database.Postgres.User

config :clean_architecture,
  ecto_repos: [CleanArchitecture.Adapter.Database.Postgres]

config :clean_architecture, CleanArchitecture.Adapter.Database.Postgres,
  show_sensitive_data_on_connection_error: true,
  database: "clean_architecture_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
