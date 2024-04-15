defmodule BookshelfEx.TradesTest do
  use BookshelfEx.DataCase
  import BookshelfEx.Factory
  alias BookshelfEx.{Trades, Trades.Trade}

  describe "create_trade/1" do
    test "trade is created successfully" do
      user = insert(:account)
      reservation = insert(:reservation, user: user.account)

      user2 = insert(:account)
      reservation2 = insert(:reservation, user: user2.account)

      assert {:ok, _} =
               Trades.create_trade(%{
                 sending_reservation_id: reservation.id,
                 receiving_reservation_id: reservation2.id
               })
    end
  end

  describe "get_user_reservation_trade/2" do
    test "get the user trading request for a certain reservation" do
      user = insert(:account)
      reservation = insert(:reservation, user: user.account)

      user2 = insert(:account)
      reservation2 = insert(:reservation, user: user2.account)

      trade =
        insert(:trade, sending_reservation: reservation2, receiving_reservation: reservation)

      assert %Trade{} = Trades.get_user_reservation_trade(reservation.id, user2.account.id)
    end
  end

  describe "update_trade_availability/2" do
    test "updates the trade availability from true to false" do
      user = insert(:account)
      reservation = insert(:reservation, user: user.account)

      user2 = insert(:account)
      reservation2 = insert(:reservation, user: user2.account)

      trade =
        insert(:trade, sending_reservation: reservation2, receiving_reservation: reservation)

      assert {:ok, trade} = Trades.update_trade_availability(trade, %{available: false})

      assert trade.available == false
    end
  end
end
