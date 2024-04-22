defmodule BookshelfEx.Services.ReturnBookServiceTest do
  use BookshelfEx.DataCase
  import BookshelfEx.Factory
  import Swoosh.TestAssertions
  alias BookshelfEx.{Services.ReturnBookService, Users.User}

  setup do
    user = insert(:account)
    reservation = insert(:reservation, user: user.account)
    {:ok, %{user: user, reservation: reservation}}
  end

  describe "return_book/1" do
    test "it returns the reservation and notifies users", %{reservation: reservation, user: user} do
      admin = insert(:account, account: build(:user, is_admin: true))
      notification_request = insert(:notification, reservation: reservation)
      assert {:ok, reservation} = ReturnBookService.return_book(reservation.id)

      assert_emails_sent([
        %{to: {User.full_name(admin.account), admin.email}},
        %{
          to: {User.full_name(notification_request.user.account), notification_request.user.email}
        }
      ])

      refute is_nil(reservation.returned_on)
    end
  end
end
