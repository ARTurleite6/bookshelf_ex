defmodule BookshelfEx.ReservationsTest do
  use BookshelfEx.DataCase

  alias BookshelfEx.Reservations
  alias BookshelfEx.Repo
  import BookshelfEx.Factory

  describe "list_reservations/0" do
    test "it lists all reservations" do
      user = insert(:account)
      reservations = insert_list(3, :reservation, user: user.account)

      assert reservations |> Repo.reload!() == Reservations.list_reservations()
    end
  end

  describe "return_by_reservation_id/1" do
    test "reservation cannot be revised" do
      user = insert(:account)
      reservation = insert(:reservation, returned_on: DateTime.utc_now(), user: user.account)

      assert {:error, _} = Reservations.return_by_reservation_id(reservation.id)
    end
  end
end
