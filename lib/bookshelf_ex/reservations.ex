defmodule BookshelfEx.Reservations do
  alias BookshelfEx.Reservations.Reservation
  alias BookshelfEx.Repo

  import Ecto.Query

  def company_reservations(user_id) do
    Repo.all(from r in Reservation, where: r.user_id == ^user_id)
  end

  def return_by_reservation_id(id) do
    Repo.get(Reservation, id)
    |> Reservation.return_changeset(%{returned_on: Date.utc_today()})
    |> Repo.update()
  end

  def with_assoc(%Reservation{} = reservation, assocs) do
    Repo.preload(reservation, assocs)
  end
end
