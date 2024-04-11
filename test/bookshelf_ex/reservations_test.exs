defmodule BookshelfEx.ReservationsTest do
  use BookshelfEx.DataCase
  import BookshelfEx.Factory
  alias BookshelfEx.Repo
  alias BookshelfEx.Reservations

  describe "list_reservations/0" do
    test "it lists all reservations" do
      user = insert(:account)
      reservations = insert_list(3, :reservation, user: user.account)

      assert reservations |> Repo.reload!() == Reservations.list_reservations()
    end
  end

  describe "company_reservations/1" do
    test "it lists all reservations of the company" do
      user = insert(:account)
      reservations = insert_list(3, :reservation, user: user.account)
      another_user = insert(:account)

      assert reservations == Reservations.company_reservations(another_user.account.id) |> Reservations.with_assoc([:user, :book])
    end
  end

  describe "return_by_reservation_id/1" do
    test "reservation cannot be revised" do
      user = insert(:account)
      reservation = insert(:reservation, returned_on: DateTime.utc_now(), user: user.account)

      assert {:error, _} = Reservations.return_by_reservation_id(reservation.id)
    end
  end

  describe "add_notification_request" do
    test "notification request inserted successfully" do
      user = insert(:account)
      current_user = insert(:account)
      reservation = insert(:reservation, returned_on: nil, user: user.account)

      assert {:ok, notification_request} =
               Reservations.add_notification_request(reservation, current_user.id)

      assert notification_request.user_id == current_user.id
      assert notification_request.reservation_id == reservation.id
    end

    test "error when user is the same as the reservation owner" do
      user = insert(:account)
      reservation = insert(:reservation, returned_on: nil, user: user.account)

      assert {:error, _} =
               Reservations.add_notification_request(reservation, user.id)
    end
  end

  describe "user_notification_request" do
    test "get the user notification request for a given reservation" do
      user = insert(:account)
      reservation = insert(:reservation, returned_on: nil, user: user.account)

      notification_request = insert(:notification_request, reservation: reservation)

      notification =
        Reservations.user_notification_request(reservation.id, notification_request.user_id)

      assert notification.id == notification_request.id
    end
  end
end
