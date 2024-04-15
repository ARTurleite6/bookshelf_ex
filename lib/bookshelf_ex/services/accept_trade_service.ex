defmodule BookshelfEx.Services.AcceptTradeService do
  alias BookshelfEx.Books
  alias BookshelfEx.Repo
  alias BookshelfEx.Reservations
  alias BookshelfEx.Trades

  def accept_trade(trade) do
    Repo.transaction(fn -> transaction(trade) end)
  end

  defp transaction(trade) do
    trade =
      trade
      |> Trades.with_assoc(
        sending_reservation: [:user, :book],
        receiving_reservation: [:user, :book]
      )

    trade = Trades.update_trade_availability!(trade, %{available: false})

    Reservations.return_by_reservation_id!(trade.sending_reservation_id)
    Reservations.return_by_reservation_id!(trade.receiving_reservation_id)

    new_reservation_1 =
      Books.reserve_book!(trade.sending_reservation.book, trade.receiving_reservation.user)

    new_reservation_2 =
      Books.reserve_book!(trade.receiving_reservation.book, trade.sending_reservation.user)

    {trade, new_reservation_1, new_reservation_2}
  end
end
