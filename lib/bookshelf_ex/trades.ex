defmodule BookshelfEx.Trades do
  import Ecto.Query

  alias BookshelfEx.Reservations.Reservation
  alias BookshelfEx.Repo
  alias BookshelfEx.Trades.Trade

  def create_trade(attrs) do
    %Trade{}
    |> Trade.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_reservation_trade(reservation_id, user_id) do
    from(t in Trade,
      join: r in Reservation,
      on: t.receiving_reservation_id == r.id,
      join: r2 in Reservation,
      on: t.sending_reservation_id == r2.id,
      where: r2.user_id == ^user_id and r.id == ^reservation_id
    )
    |> Repo.one()
  end
end
