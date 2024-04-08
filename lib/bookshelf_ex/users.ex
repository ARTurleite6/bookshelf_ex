defmodule BookshelfEx.Users do
  alias BookshelfEx.Repo
  alias BookshelfEx.Accounts

  def with_account(%Accounts.User{} = user, opts \\ []) do
    preloads = Keyword.get(opts, :preloads, [:account])
    user |> Repo.preload(preloads)
  end
end
