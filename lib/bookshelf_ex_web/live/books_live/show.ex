defmodule BookshelfExWeb.BooksLive.Show do
  alias BookshelfEx.Services.ReserveBookService
  alias BookshelfEx.Users
  use BookshelfExWeb, :live_view
  alias BookshelfEx.Books
  alias BookshelfEx.Books.Book
  alias BookshelfEx.Users.User
  alias BookshelfEx.Repo

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    book = Books.get_book!(id, assocs: [:active_reader])

    socket =
      socket
      |> assign(book: book)
      |> assign(
        :current_user,
        Users.with_assoc(socket.assigns.current_user, :account)
      )

    {:ok, socket}
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
