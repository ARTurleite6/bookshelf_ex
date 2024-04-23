defmodule BookshelfEx.TradesTest do
  use BookshelfEx.DataCase
  import BookshelfEx.Factory
  import Swoosh.TestAssertions
  alias BookshelfEx.{Trades, Trades.Trade}

  describe "create_trade/1" do
    setup do
      user = insert(:account)
      reservation = insert(:reservation, user: user.account)

      user2 = insert(:account)
      reservation2 = insert(:reservation, user: user2.account)

      %{user: user, reservation: reservation, user2: user2, reservation2: reservation2}
    end

    test "trade is created successfully", %{
      user2: user2,
      reservation: reservation,
      reservation2: reservation2
    } do
      assert {:ok, _} =
               Trades.create_trade(%{
                 sending_reservation_id: reservation.id,
                 receiving_reservation_id: reservation2.id
               })

      assert_email_sent(to: user2.email)
    end
  end

  describe "get_user_reservation_trade/2" do
    test "get the user trading request for a certain reservation" do
      user = insert(:account)
      reservation = insert(:reservation, user: user.account)

      user2 = insert(:account)
      reservation2 = insert(:reservation, user: user2.account)

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

      assert {:ok, trade} = Trades.update_trade_availability(trade, %{status: :accepted})

      assert trade.status == :accepted
    end
  end
end
