defmodule CleanArchitecture.Adapter.Database.Postgres do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :clean_architecture,
    adapter: Ecto.Adapters.Postgres
end
