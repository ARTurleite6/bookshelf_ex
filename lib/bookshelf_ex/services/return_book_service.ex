defmodule BookshelfEx.Services.ReturnBookService do
  alias BookshelfEx.Mailers.ReservationEndedMailer
  alias BookshelfEx.Mailer
  alias BookshelfEx.Users
  alias BookshelfEx.Reservations
  alias BookshelfEx.Mailers.AdminMailer

  @spec return_book(reservation_id :: integer()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def return_book(reservation_id) do
    case Reservations.return_by_reservation_id(reservation_id) do
      {:ok, reservation} ->
        reservation = Reservations.with_assoc(reservation, :book)
        notify_admins(reservation)

        notify_users(reservation)

        {:ok, reservation}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp notify_admins(book) do
    admins = Users.list_admins()

    for admin <- admins do
      AdminMailer.new_reservation_ending_email(book, admin)
    end
    |> Mailer.deliver_many()
  end

  defp notify_users(reservation) do
    reservation = Reservations.with_assoc(reservation, [:users_to_notify])

    for user <- reservation.users_to_notify do
      ReservationEndedMailer.reservation_ended_mail(reservation.book, user)
    end
    |> Mailer.deliver_many()
  end
end
