defmodule BookshelfEx.TradesTest do
  use BookshelfEx.DataCase
  import BookshelfEx.Factory
  alias BookshelfEx.Trades

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
end
