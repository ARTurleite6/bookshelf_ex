defmodule BookshelfEx.Mailers.ReservationEndedMailer do
  alias BookshelfEx.Users
  alias BookshelfEx.Books.Book
  alias BookshelfEx.Accounts
  alias BookshelfEx.Mailer

  import Swoosh.Email

  def reservation_ended_mail(%Book{} = book, %Accounts.User{} = user) do
    user = Accounts.with_assoc(user, :account)

    new()
    |> from(Mailer.default_from())
    |> to({Users.User.full_name(user), user.email})
    |> subject("The #{book.title} is finally available")
    |> html_body("<h1>The book you asked for notificaitons is finally available")
  end
end
