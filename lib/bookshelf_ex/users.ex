defmodule BookshelfEx.Users do
  alias BookshelfEx.Repo
  alias BookshelfEx.Accounts
  alias BookshelfEx.Accounts.User

  import Ecto.Query

  def list_admins(opts \\ []) do
    assocs = Keyword.get(opts, :assocs, [])

    Repo.all(
      from u in User, join: a in assoc(u, :account), where: a.is_admin == true, preload: ^assocs
    )
  end

  def with_assoc(%Accounts.User{} = user, assoc) do
    Repo.preload(user, assoc)
  end

  def active_reservation(%Accounts.User{} = user) do
    user
    |> with_assoc(account: [:active_reservation])
    |> Map.get(:account)
    |> Map.get(:active_reservation)
  end
end
