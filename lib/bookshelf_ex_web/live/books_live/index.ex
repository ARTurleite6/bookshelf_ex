defmodule BookshelfExWeb.BooksLive.Index do
  alias BookshelfEx.Repo
  use BookshelfExWeb, :live_view
  alias BookshelfEx.Books
  alias BookshelfEx.Books.Book
  alias BookshelfEx.Users
  alias BookshelfEx.Reservations

  embed_templates "components/*"

  def active_reservation(assigns)

  @impl true
  def mount(_params, _session, socket) do
    active_reservation =
      Users.active_reservation(socket.assigns.current_user |> Users.with_assoc(:account))

    active_reservation =
      if !is_nil(active_reservation), do: Reservations.with_assoc(active_reservation, :book)

    socket =
      socket
      |> stream(:books, Books.list_books())
      |> assign(:active_reservation, active_reservation)
      |> assign(
        :company_reservations,
        Reservations.company_reservations(socket.assigns.current_user.id)
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(params, socket.assigns.live_action, socket)}
  end

  @impl true
  def handle_event("return_book", %{"reservation_id" => reservation_id}, socket) do
    case Reservations.return_by_reservation_id(reservation_id) do
      {:ok, _} ->
        socket =
          socket
          |> assign(:active_reservation, nil)
          |> put_flash(:info, "Book sucessfully returned")
          |> assign(:current_user, socket.assigns.current_user |> Repo.reload!())

        {:noreply, socket}

      {:error, _} ->
        socket = socket |> put_flash(:error, "Error returning the book")
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => book_id}, socket) do
    book = Books.get_book!(book_id)

    Books.delete_book!(book)
    {:noreply, stream_delete(socket, :books, book)}
  end

  @impl true
  def handle_info({BookshelfExWeb.BooksLive.Form, {:saved, book}}, socket) do
    {:noreply, stream_insert(socket, :books, book)}
  end

  defp apply_action(_params, :index, socket) do
    socket
    |> assign(:title, "Listing Books")
    |> assign(:book, nil)
  end

  defp apply_action(_params, :new, socket) do
    socket
    |> assign(:title, "Listing Books")
    |> assign(:book, %Book{})
  end

  defp apply_action(%{"id" => id}, :edit, socket) do
    socket
    |> assign(:title, "Listing Books")
    |> assign(:book, Books.get_book!(id))
  end

  defp truncate(text, length \\ 200) do
    String.slice(text, 0..length) <> if String.length(text) > length, do: "...", else: ""
  end
end
