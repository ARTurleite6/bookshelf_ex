defmodule BookshelfEx.Services.ReturnBookServiceTest do
  alias BookshelfEx.Services.ReturnBookService
  use BookshelfEx.DataCase
  import BookshelfEx.Factory

  describe "return_book/1" do
    test "it returns the reservation" do
      user = insert(:account)
      reservation = insert(:reservation, user: user.account)

      assert {:ok, reservation} = ReturnBookService.return_book(reservation.id)

      refute is_nil(reservation.returned_on)
    end
  end
end
