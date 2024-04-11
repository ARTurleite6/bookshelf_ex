defmodule BookshelfEx.Mailers.ReadingProgressMailer do
  alias BookshelfEx.Reservations
  alias BookshelfEx.Reservations.Reservation
  alias BookshelfEx.Users.User
  import Swoosh.Email

  def new_reading_progress_email(%Reservation{} = reservation) do
    reservation = Reservations.with_assoc(reservation, [:user, :book])

    new()
    |> from({"Deemaze", "bookshelf@deemaze.com"})
    |> to({User.full_name(reservation.user), reservation.user.email})
    |> subject("Enjoying the #{reservation.book.title}")
    |> html_body(body(reservation))
  end

  defp body(%Reservation{} = reservation) do
    """
    <div>
      <p class="mb-s">Hello #{reservation.user.first_name},</p>
      <p>
        Whether you're deep into the plot twists or savoring each chapter, we'd love to hear about your reading progress.
        Feel free to share your thoughts, favorite moments, or any questions you might have.
      </p>
      <p>Keep those pages turning!</p>
      <p class="mt-s">Cheers!</p>
    </div>
    """
  end
end
