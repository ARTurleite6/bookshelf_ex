defmodule BookshelfEx.Reservations do
  alias BookshelfEx.Notifications.NotificationRequest
  alias BookshelfEx.Repo
  alias BookshelfEx.Reservations.Reservation

  import Ecto.Query

  def list_reservations(opts \\ []) do
    assocs = Keyword.get(opts, :assocs, [])
    Repo.all(from(r in Reservation, order_by: [desc: r.inserted_at])) |> Repo.preload(assocs)
  end

  def user_reservations(user_id, assocs \\ []) do
    Repo.all(
      from r in Reservation,
        where: r.user_id == ^user_id,
        preload: ^assocs,
        order_by: [desc: :inserted_at]
    )
  end

  def add_notification_request(%Reservation{} = reservation, user_id) do
    reservation
    |> Ecto.build_assoc(:notification_requests, user_id: user_id)
    |> NotificationRequest.changeset(%{})
    |> NotificationRequest.validate_user_cannot_be_the_same_as_reservation_owner()
    |> Repo.insert()
  end

  def get_reservation!(id) do
    Reservation |> Repo.get!(id)
  end

  def user_notification_request(reservation_id, user_id) do
    Repo.one(
      from(n in NotificationRequest,
        where: [user_id: ^user_id, reservation_id: ^reservation_id]
      )
    )
  end

  def company_reservations(user_id, opts \\ []) do
    assocs = Keyword.get(opts, :assocs, [])

    Repo.all(from(r in Reservation, where: r.user_id != ^user_id and is_nil(r.returned_on)))
    |> Repo.preload(assocs)
  end

  def return_by_reservation_id!(id) do
    Reservation
    |> Repo.get(id)
    |> Reservation.return_changeset(%{returned_on: Date.utc_today()})
    |> Repo.update()
  end

  def return_by_reservation_id(id) do
    Reservation
    |> Repo.get(id)
    |> Reservation.return_changeset(%{returned_on: Date.utc_today()})
    |> Repo.update()
  end

  def active_reservations_with_one_month do
    query =
      from(r in Reservation,
        where:
          is_nil(r.returned_on) and
            r.inserted_at <
              ^(DateTime.utc_now()
                |> DateTime.add(-30, :day))
      )

    Repo.all(query)
  end

  def with_assoc(reservation_or_reservations, assocs) do
    Repo.preload(reservation_or_reservations, assocs)
  end
end
