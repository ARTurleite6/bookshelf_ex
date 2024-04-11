defmodule BookshelfExWeb.ReservationsLive.Index do
  alias BookshelfEx.Services.ReturnBookService
  use BookshelfExWeb, :live_view

  alias BookshelfEx.{Reservations, Reservations.Reservation}

  @impl true
  def mount(_params, _session, socket) do
    reservations = Reservations.list_reservations(assocs: [:book])
    {:ok, stream(socket, :reservations, reservations)}
  end

  @impl true
  def handle_event("return_book", %{"reservation_id" => reservation_id}, socket) do
    case ReturnBookService.return_book(reservation_id) do
      {:ok, reservation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Book sucessfully returned")
         |> stream_insert(:reservations, reservation |> Reservations.with_assoc([:book]))}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, "Error returning the book")}
    end
  end
end
