defmodule BookshelfEx.Users do
  alias BookshelfEx.Users
  alias BookshelfEx.Repo
  alias BookshelfEx.Accounts

  def register_user(attrs) do
    %Users.User{}
    |> Users.User.changeset_registration(attrs)
    |> Repo.insert()
  end

  def change_user_registration(%Users.User{} = user, attrs \\ %{}) do
    Users.User.changeset_registration(user, attrs)
  end

  def create_user(attrs) do
    %Users.User{}
    |> Users.User.changeset_registration(attrs)
    |> Repo.insert()
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
