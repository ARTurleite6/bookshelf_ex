defmodule BookshelfEx.Services.ReserveBookServiceTest do
  use BookshelfEx.DataCase
  import BookshelfEx.Factory
  import Swoosh.TestAssertions
  alias BookshelfEx.{Reservations, Services.ReserveBookService, Users.User}

  describe "reserve_book/2" do
    test "it creates the reservation" do
      admin = insert(:account, account: build(:user, is_admin: true))
      book = insert(:book)
      user = insert(:account)
      assert {:ok, reservation} = ReserveBookService.reserve_book(book, user)
      reservation = Reservations.with_assoc(reservation, [:book, :user])

      assert reservation.book == book
      assert reservation.user == user.account
      assert reservation.book.office == user.account.office

      assert_emails_sent([
        %{
          to: {
            User.full_name(admin.account),
            admin.email
          }
        }
      ])
    end
  end
end
