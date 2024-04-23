defmodule BookshelfEx.Trades.TradeNotifier do
  import Swoosh.Email

  alias BookshelfEx.{Mailer, Reservations.Reservation, Trades, Trades.Trade, Users.User}

  defp deliver(recipient, subject, body) do
    new()
    |> to(recipient)
    |> from({"Deemaze", "deemaze@deemaze.com"})
    |> subject(subject)
    |> text_body(body)
    |> Mailer.deliver()
  end

  def deliver_new_trade_request(%Trade{} = trade) do
    trade = Trades.preload_reservations(trade)
    %Reservation{user: receiving_user, book: receiving_book} = trade.receiving_reservation
    %Reservation{user: sending_user, book: sending_book} = trade.sending_reservation
    email = receiving_user.user.email

    deliver(
      email,
      "Trading request on your current book #{receiving_book.title} by the book #{sending_book.title}",
      """
      Hi #{User.full_name(receiving_user)},

      The user #{User.full_name(sending_user)} with the email #{sending_user.user.email} sent a request to
      trade the book you are currently reading with his
      """
    )
  end
end
