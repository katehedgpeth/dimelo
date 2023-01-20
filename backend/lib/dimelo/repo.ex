defmodule Dimelo.Repo do
  use Ecto.Repo,
    otp_app: :dimelo,
    adapter: Ecto.Adapters.Postgres
end
