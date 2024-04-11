defmodule BookshelfEx.Users do

  alias BookshelfEx.Repo
  alias BookshelfEx.{Accounts, Accounts.User}

  import Ecto.Query

  def list_admins(opts \\ []) do
    assocs = Keyword.get(opts, :assocs, [])

    Repo.all(
      from u in User, join: a in assoc(u, :account), where: a.is_admin == true, preload: ^assocs
    )
  end

  def with_assoc(user_or_users, assoc) do
    Repo.preload(user_or_users, assoc)
  end

  def active_reservation(%Accounts.User{} = user) do
    user
    |> with_assoc(account: [:active_reservation])
    |> Map.get(:account)
    |> Map.get(:active_reservation)
  end
end
