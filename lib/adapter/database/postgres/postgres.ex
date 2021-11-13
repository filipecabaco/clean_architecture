defmodule CleanArchitecture.Adapter.Database.Postgres do
  use Ecto.Repo,
    otp_app: :clean_architecture,
    adapter: Ecto.Adapters.Postgres
end
