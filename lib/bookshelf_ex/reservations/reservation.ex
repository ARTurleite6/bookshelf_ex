defmodule BookshelfEx.Reservations.Reservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reservations" do
    field :returned_on, :date
    belongs_to :user, BookshelfEx.Accounts.User
    belongs_to :book, BookshelfEx.Books.Book

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:returned_on])
    |> validate_required([:returned_on])
  end
end
