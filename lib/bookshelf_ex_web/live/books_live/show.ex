defmodule BookshelfExWeb.BooksLive.Show do
  alias BookshelfEx.Trades
  use BookshelfExWeb, :live_view

  alias BookshelfEx.{Reservations, Reservations.Reservation}
  alias BookshelfEx.{Users, Users.User}
  alias BookshelfEx.{Books, Books.Book}
  alias BookshelfEx.Repo
  alias BookshelfEx.Services.ReserveBookService

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    book = Books.get_book!(id, assocs: [:active_reader])
    reservation = book.active_reservation
    current_user = socket.assigns.current_user |> Users.with_assoc(account: [:active_reservation])

    notification_request =
      if reservation,
        do: Reservations.user_notification_request(reservation.id, current_user.id),
        else: nil

    trade_request =
      if reservation,
        do: Trades.get_user_reservation_trade(reservation.id, current_user.account.id),
        else: nil

    socket =
      socket
      |> assign(book: book)
      |> assign(trade_request: trade_request)
      |> assign(notification_request: notification_request)
      |> assign(
        :current_user,
        current_user
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("request_trade", _params, socket) do
    receiving_reservation = socket.assigns.book.active_reservation
    sending_reservation = socket.assigns.current_user.account.active_reservation

    case Trades.create_trade(
           receiving_reservation_id: receiving_reservation.id,
           sending_reservation_id: sending_reservation.id
         ) do
      {:ok, trade} ->
        socket =
          socket
          |> put_flash(:info, "Requested trade to this book created successfully")
          |> assign(:trade_request, trade)

        {:noreply, socket}

      {:error, _} ->
        socket =
          socket
          |> put_flash(:error, "Error requesting a trade for this book")

        {:noreply, socket}
    end
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
