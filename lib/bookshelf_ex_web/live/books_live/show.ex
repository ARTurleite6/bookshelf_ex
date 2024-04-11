defmodule BookshelfExWeb.BooksLive.Show do
  use BookshelfExWeb, :live_view

  alias BookshelfEx.{Reservations, Reservations.Reservation}
  alias BookshelfEx.{Users, Users.User}
  alias BookshelfEx.{Books, Books.Book}
  alias BookshelfEx.Accounts
  alias BookshelfEx.Services.ReserveBookService
  alias BookshelfEx.Repo

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    book = Books.get_book!(id, assocs: [:active_reader])
    reservation = book.active_reservation

    %Accounts.User{id: user_id} = socket.assigns.current_user

    notification_request =
      if reservation,
        do: Reservations.user_notification_request(reservation.id, user_id),
        else: nil

    socket =
      socket
      |> assign(book: book)
      |> assign(notification_request: notification_request)
      |> assign(
        :current_user,
        Users.with_assoc(socket.assigns.current_user, :account)
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("add_notifier", _params, socket) do
    current_user = socket.assigns.current_user
    reservation = socket.assigns.book.active_reservation

    case Reservations.add_notification_request(reservation, current_user.id) do
      {:ok, notification_request} ->
        socket =
          socket
          |> put_flash(:info, "Notification request successfully added")
          |> assign(:notification_request, notification_request)

        {:noreply, socket}

      {:error, _} ->
        socket =
          socket
          |> put_flash(:error, "Error adding notification request")

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("reserve", _params, socket) do
    current_user = socket.assigns.current_user
    book = socket.assigns.book

    reservation =
      ReserveBookService.reserve_book(book, current_user)

    case reservation do
      {:ok, _} ->
        socket =
          socket
          |> assign(:book, Repo.reload!(book) |> Repo.preload(:active_reader))
          |> put_flash(:info, "Book sucessfully reserved")

        {:noreply, socket}

      {:error, _} ->
        socket =
          socket
          |> put_flash(:error, "Error reserving the book")

        {:noreply, socket}
    end
  end
end
