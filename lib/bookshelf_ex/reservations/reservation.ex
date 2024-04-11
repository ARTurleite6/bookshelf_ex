defmodule BookshelfEx.Reservations.Reservation do
  use Ecto.Schema
  import Ecto.Changeset
  alias BookshelfEx.Books.Book
  alias BookshelfEx.Repo

  schema "reservations" do
    field :returned_on, :date

    belongs_to :user, BookshelfEx.Users.User
    belongs_to :book, BookshelfEx.Books.Book

    has_many :notification_requests, BookshelfEx.Notifications.NotificationRequest
    has_many :users_to_notify, through: [:notification_requests, :user]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:user_id, :book_id, :returned_on])
    |> validate_required([:user_id, :book_id])
    |> validate_book_has_no_active_reservation()
    |> validate_user_has_no_active_reservation()
  end

  def return_changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:returned_on])
    |> validate_required([:returned_on])
    |> validate_returned_on_cannot_be_in_past()
    |> validate_returned_on_cannot_be_revised(reservation)
  end

  def returned?(reservation) do
    !is_nil(reservation.returned_on)
  end

  def owner?(%__MODULE__{user_id: owner_id}, user_id) do
    owner_id == user_id
  end

  defp validate_returned_on_cannot_be_in_past(changeset) do
    if get_field(changeset, :returned_on) < Date.utc_today() do
      add_error(changeset, :returned_on, "cannot be in the past")
    else
      changeset
    end
  end

  defp validate_returned_on_cannot_be_revised(changeset, reservation_was) do
    returned_on_was = reservation_was.returned_on

    if returned_on_was do
      add_error(changeset, :returned_on, "cannot be revised")
    else
      changeset
    end
  end

  defp validate_user_has_no_active_reservation(changeset) do
    user_id = get_field(changeset, :user_id)

    is_reserved =
      Repo.get!(BookshelfEx.Users.User, user_id)
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
