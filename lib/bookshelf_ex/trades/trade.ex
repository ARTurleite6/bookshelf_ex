defmodule BookshelfEx.Trades.Trade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trades" do
    field :status, Ecto.Enum, values: [:pending, :rejected, :accepted]

    belongs_to :sending_reservation, BookshelfEx.Reservations.Reservation
    belongs_to :receiving_reservation, BookshelfEx.Reservations.Reservation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(trade, attrs) do
    trade
    |> cast(attrs, [:sending_reservation_id, :receiving_reservation_id, :status])
    |> validate_required([:sending_reservation_id, :receiving_reservation_id])
    |> unique_constraint([:sending_reservation_id, :receiving_reservation_id],
      name: :trades_sending_reservation_id_receiving_reservation_id_index
    )
  end

  def availability_changeset(trade, attrs) do
    trade
    |> cast(attrs, [:status])
  end
end
