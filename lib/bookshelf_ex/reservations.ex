defmodule BookshelfEx.Reservations do
  alias BookshelfEx.Reservations.Reservation
  alias BookshelfEx.Repo

  import Ecto.Query

  def list_reservations(opts \\ []) do
    assocs = Keyword.get(opts, :assocs, [])
    Repo.all(from r in Reservation, order_by: [desc: r.inserted_at]) |> Repo.preload(assocs)
  end

  def company_reservations(user_id, opts \\ []) do
    assocs = Keyword.get(opts, :assocs, [])

    Repo.all(from r in Reservation, where: r.user_id != ^user_id and not is_nil(r.returned_on))
    |> Repo.preload(assocs)
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
