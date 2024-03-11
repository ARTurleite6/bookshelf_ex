defmodule BookshelfEx.Repo do
  use Ecto.Repo,
    otp_app: :bookshelf_ex,
    adapter: Ecto.Adapters.Postgres
end
