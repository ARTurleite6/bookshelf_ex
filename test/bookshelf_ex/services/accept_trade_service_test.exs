defmodule BookshelfEx.Services.AcceptTradeServiceTest do
  alias BookshelfEx.Reservations.Reservation
  use BookshelfEx.DataCase
  import BookshelfEx.Factory

  alias BookshelfEx.Services.AcceptTradeService

  describe "accept_trade/1" do
    test "accepts the trade, creating new ones" do
      user = insert(:account)
      reservation = insert(:reservation, user: user.account)

      user2 = insert(:account)
      reservation2 = insert(:reservation, user: user2.account)

      trade =
        insert(:trade, sending_reservation: reservation2, receiving_reservation: reservation)

      assert {:ok, {trade, reservation_1, reservation_2}} =
               AcceptTradeService.accept_trade(trade)

      assert trade.available == false

      assert reservation_2.user_id == user2.account.id
      assert reservation_2.book_id == reservation.book_id

      assert reservation_1.user_id == user.account.id
      assert reservation_1.book_id == reservation2.book_id
    end
  end
end
