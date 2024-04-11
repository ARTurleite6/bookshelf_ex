defmodule BookshelfEx.Trades.Trade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trades" do
    belongs_to :sending_reservation, BookshelfEx.Reservations.Reservation
    belongs_to :receiving_reservation, BookshelfEx.Reservations.Reservation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(trade, attrs) do
    trade
    |> cast(attrs, [:sending_reservation_id, :receiving_reservation_id])
    |> validate_required([:sending_reservation_id, :receiving_reservation_id])
    |> unique_constraint([:sending_reservation_id, :receiving_reservation_id])
  end
end