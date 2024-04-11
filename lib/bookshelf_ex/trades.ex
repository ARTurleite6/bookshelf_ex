defmodule BookshelfEx.Trades do

  alias BookshelfEx.Trades.Trade
  alias BookshelfEx.Repo

  def create_trade(attrs) do
    %Trade{}
    |> Trade.changeset(attrs)
    |> Repo.insert()
  end

end
