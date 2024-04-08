defmodule BookshelfEx.Reservations.Reservation do
  use Ecto.Schema
  import Ecto.Changeset
  alias BookshelfEx.Books.Book
  alias BookshelfEx.Repo

  schema "reservations" do
    belongs_to :user, BookshelfEx.Users.User
    belongs_to :book, BookshelfEx.Books.Book

    field :returned_on, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:user_id, :book_id, :returned_on])
    |> validate_required([:user_id, :book_id, :returned_on])
    |> validate_book_has_no_active_reservation()
    |> validate_user_has_no_active_reservation()
  end

  defp validate_user_has_no_active_reservation(changeset) do
    user_id = get_field(changeset, :user_id)

    is_reserved =
      Repo.get!(BookshelfEx.Accounts.User, user_id)
      |> BookshelfEx.Users.User.actively_reading?()

    if is_reserved do
      add_error(changeset, :user_id, "already has an active reservation")
    else
      changeset
    end
  end

  defp validate_book_has_no_active_reservation(changeset) do
    book_id = get_field(changeset, :book_id)

    is_reserved = Book.reserved?(Repo.get!(Book, book_id))

    if is_reserved do
      add_error(changeset, :book_id, "already has an active reservation")
    else
      changeset
    end
  end
end
