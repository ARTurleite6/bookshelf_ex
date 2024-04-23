defmodule BookshelfEx.Trades do
  import Ecto.Query

  alias BookshelfEx.{
    Repo,
    Reservations.Reservation,
    Trades.Trade,
    Trades.TradeNotifier
  }

  def user_involved_trades(user_id) do
    Repo.all(
      from(t in Trade,
        join: r in Reservation,
        on: r.id == t.sending_reservation_id or r.id == t.receiving_reservation_id,
        where: r.user_id == ^user_id,
        order_by: [desc: :inserted_at]
      )
    )
  end

  def preload_reservations(trade_or_trades) do
    trade_or_trades
    |> Repo.preload(
      sending_reservation: [:book, user: [:user]],
      receiving_reservation: [:book, user: [:user]]
    )
  end

  def create_trade(attrs) do
    trade =
      %Trade{}
      |> Trade.changeset(attrs)
      |> Repo.insert()

    with {:ok, trade} <- trade do
      TradeNotifier.deliver_new_trade_request(trade)
    end

    trade
  end

  def get_trade!(trade_id) do
    Repo.get!(Trade, trade_id)
  end

  def with_assoc(%Trade{} = trade, assocs) do
    Repo.preload(trade, assocs)
  end

  def update_trade_availability(trade, attrs) do
    trade
    |> Trade.availability_changeset(attrs)
    |> Repo.update()
  end

  def update_trade_availability!(trade, attrs) do
    trade
    |> Trade.availability_changeset(attrs)
    |> Repo.update!()
  end

  def user_receiving_trading_requests(user_id, assocs \\ []) do
    Repo.all(
      from t in Trade,
        join: r in Reservation,
        on: r.id == t.receiving_reservation_id,
        where: r.user_id == ^user_id,
        order_by: [desc: t.inserted_at],
        preload: ^assocs
    )
  end

  def get_user_reservation_trade(reservation_id, user_id, assocs \\ []) do
    Repo.one(
      from(t in Trade,
        join: r in Reservation,
        on: t.receiving_reservation_id == r.id,
        join: r2 in Reservation,
        on: t.sending_reservation_id == r2.id,
        where: r2.user_id == ^user_id and r.id == ^reservation_id,
        preload: ^assocs
      )
    )
  end
end
