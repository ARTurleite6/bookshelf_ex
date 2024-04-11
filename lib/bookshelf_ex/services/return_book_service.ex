defmodule BookshelfEx.Services.ReturnBookService do
  alias BookshelfEx.Reservations.Reservation
  alias Ecto.Adapter.Schema
  alias BookshelfEx.Mailer
  alias BookshelfEx.Books
  alias BookshelfEx.Users
  alias BookshelfEx.Reservations
  alias BookshelfEx.Mailers.AdminMailer

  @spec return_book(reservation_id :: integer()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def return_book(reservation_id) do
    admins = Users.list_admins()

    case Reservations.return_by_reservation_id(reservation_id) do
      {:ok, reservation} ->
        book = Books.get_book!(reservation.book_id)

        for admin <- admins do
          AdminMailer.new_reservation_ending_email(book, admin)
        end
        |> Mailer.deliver_many()

        {:ok, reservation}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
