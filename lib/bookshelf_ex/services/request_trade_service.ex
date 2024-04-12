defmodule BookshelfEx.Services.RequestTradeService do
  alias BookshelfEx.Mailer
  alias BookshelfEx.Accounts
  alias BookshelfEx.Trades
  alias BookshelfEx.Mailers.TradingRequestMailer

  def request_trade(receiving_reservation, sending_reservation) do
    case(
      Trades.create_trade(%{
        receiving_reservation_id: receiving_reservation.id,
        sending_reservation_id: sending_reservation.id
      })
    ) do
      {:ok, trade} ->
        receiving_user = Accounts.get_user!(receiving_reservation.user_id)

        receiving_user
        |> TradingRequestMailer.trading_request_email(receiving_reservation)
        |> Mailer.deliver()

        {:ok, trade}

      {:error, _} ->
        {:error, "Error requesting to trade"}
    end
  end
end
