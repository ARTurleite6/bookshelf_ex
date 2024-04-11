defmodule BookshelfEx.Mailers.AdminMailerTest do
  use BookshelfEx.DataCase
  alias BookshelfEx.Mailers.AdminMailer
  import Swoosh.TestAssertions
  import BookshelfEx.Factory

  test "new_reservation_email/2" do
    user = insert(:account)
    reservation = insert(:reservation, user: user.account)
    recipient = insert(:account)

    email = AdminMailer.new_reservation_email(reservation, recipient)
    Swoosh.Adapters.Test.deliver(email, [])

    assert_email_sent(
      subject: "New reservation on #{reservation.book.title}",
      from: {"Deemaze", "bookshelf@deemaze.com"},
      to: {BookshelfEx.Users.User.full_name(recipient.account), recipient.email}
    )
  end

  test "new_reservation_ending_email/2" do
    book = insert(:book)
    user = insert(:account)

    email = AdminMailer.new_reservation_ending_email(book, user)
    Swoosh.Adapters.Test.deliver(email, [])

    assert_email_sent(
      subject: "Reservation ending on #{book.title}",
      to: {BookshelfEx.Users.User.full_name(user.account), user.email},
      from: {"Deemaze", "bookshelf@deemaze.com"}
    )
  end
end
