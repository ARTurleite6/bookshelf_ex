defmodule BookshelfEx.Jobs.ReadingProgressEmailJob do
  alias BookshelfEx.Reservations
  alias BookshelfEx.Mailers.ReadingProgressMailer

  def send_email do
    active_reservation = Reservations.active_reservations_with_one_month()

    for reservation <- active_reservation do
      ReadingProgressMailer.new_reading_progress_email(reservation)
    end
    |> BookshelfEx.Mailer.deliver_many()
  end
end
