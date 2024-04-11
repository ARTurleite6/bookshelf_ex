defmodule BookshelfEx.Mailers.AdminMailer do
  alias BookshelfEx.Accounts.User
  alias BookshelfEx.Users
  alias BookshelfEx.Reservations.Reservation
  alias BookshelfEx.Reservations
  alias BookshelfEx.Books.Book
  import Swoosh.Email

  def new_reservation_email(reservation = %Reservation{}, %User{} = recipient) do
    recipient = Users.with_assoc(recipient, :account)
    reservation = Reservations.with_assoc(reservation, [:book, :user])

    new()
    |> to({Users.User.full_name(recipient.account), recipient.email})
    |> from({"Deemaze", "bookshelf@deemaze.com"})
    |> subject("New reservation on #{reservation.book.title}")
    |> html_body(reservation_email_body(recipient, reservation.user, reservation.book))
  end

  def new_reservation_ending_email(%Book{} = book, %User{} = recipient) do
    recipient = Users.with_assoc(recipient, :account)

    new()
    |> to({Users.User.full_name(recipient.account), recipient.email})
    |> from({"Deemaze", "bookshelf@deemaze.com"})
    |> subject("Reservation ending on #{book.title}")
    |> html_body(reservation_ending_email_body(recipient, book))
  end

  defp reservation_ending_email_body(%User{} = recipient, %Book{} = book) do
    """
    <div>
      <p class="mb-s">Hey #{recipient.account.first_name},</p>
      <p>A book has made its way back to the Bookshelf!</p>
      <p>
        <span class="font-bold">#{Users.User.full_name(recipient.account)}</span> finished reading <span class="font-bold">#{book.title}</span>.
        Why not strike up a conversation and find out if the read was worth it?
      </p>
      <p class="mt-s">Best,</p>
      <p>The Bookshelf team</p>
    </div>
    """
  end

  defp reservation_email_body(recipient, reserver, book) do
    """
    <div>
      <p class="mb-s">Hello #{recipient.account.first_name},</p>
      <p>A book has made its way out of the Bookshelf!</p>
      <p>
        <span class="font-bold">#{Users.User.full_name(reserver)}</span> started reading
        <span class="font-bold">#{book.title}</span>
      </p>
      <p class="mt-s">Best,</p>
      <p>The Bookshelf team</p>
    </div>
    """
  end
end
