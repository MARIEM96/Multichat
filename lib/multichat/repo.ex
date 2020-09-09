defmodule Multichat.Repo do
  use Ecto.Repo,
    otp_app: :multichat,
    adapter: Ecto.Adapters.Postgres
end
