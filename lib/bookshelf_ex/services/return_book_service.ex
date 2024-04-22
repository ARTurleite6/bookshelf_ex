defmodule BookshelfEx.Services.ReturnBookService do
  alias BookshelfEx.{
    Books.Book,
    Mailer,
    Reservations,
    Reservations.Reservation,
    Mailers.AdminMailer,
    Mailers.ReservationEndedMailer,
    Users
  }

  @spec return_book(reservation_id :: integer()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def return_book(reservation_id) do
    case Reservations.return_by_reservation_id(reservation_id) do
      {:ok, reservation} ->
        reservation = Reservations.with_assoc(reservation, :book)

        List.flatten([notify_admins(reservation.book), notify_users(reservation)])
        |> Mailer.deliver_many()

        {:ok, reservation}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp notify_admins(%Book{} = book) do
    admins = Users.list_admins()

    Enum.map(admins, &AdminMailer.new_reservation_ending_email(book, &1))
  end

  defp notify_users(%Reservation{} = reservation) do
    reservation = Reservations.with_assoc(reservation, [:users_to_notify])

    Enum.map(
      reservation.users_to_notify,
      &ReservationEndedMailer.reservation_ended_mail(reservation.book, &1)
    )
  end
end
