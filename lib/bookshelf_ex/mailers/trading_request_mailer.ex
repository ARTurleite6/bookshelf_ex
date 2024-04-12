defmodule BookshelfEx.Mailers.TradingRequestMailer do
  import Swoosh.Email
  alias BookshelfEx.Reservations
  alias BookshelfEx.Mailer
  alias BookshelfEx.Users.User
  alias BookshelfEx.Accounts

  def trading_request_email(receiving_user, reservation) do
    receiving_user = Accounts.with_assoc(receiving_user, [:account])
    reservation = Reservations.with_assoc(reservation, :book)

    new()
    |> from(Mailer.default_from())
    |> to({User.full_name(receiving_user.account), receiving_user.email})
    |> subject("Trade request was created for the #{reservation.book.title}")
    |> html_body(body(reservation.book))
  end

  defp body(book) do
    """
      <h1>Hello fellow User</h1>
      <p>A Trading request for the book #{book.title}</p>
    """
  end
end
