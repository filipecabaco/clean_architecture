import Config

config :clean_architecture, :database_child_spec, {CleanArchitecture.Adapter.Database.Memory, []}
config :clean_architecture, :user_database, CleanArchitecture.Adapter.Database.Memory.User

config :clean_architecture,
  ecto_repos: [CleanArchitecture.Adapter.Database.Memory]
