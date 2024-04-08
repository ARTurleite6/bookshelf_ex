defmodule BookshelfExWeb.BooksLive.Index do
  use BookshelfExWeb, :live_view
  alias BookshelfEx.Books
  alias BookshelfEx.Books.Book

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :books, Books.list_books())}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(params, socket.assigns.live_action, socket)}
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
