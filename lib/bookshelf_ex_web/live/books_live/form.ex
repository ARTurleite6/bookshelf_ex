defmodule BookshelfExWeb.BooksLive.Form do
  use BookshelfExWeb, :live_component

  alias BookshelfEx.Books

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="book-form"
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <.input field={@form[:title]} label="Title" />
        <.input type="textarea" field={@form[:description]} label="Description" />
        <.input field={@form[:cover_url]} label="Cover URL" />
        <.input
          type="select"
          field={@form[:genre]}
          options={Ecto.Enum.values(BookshelfEx.Books.Book, :genre)}
        />
        <:actions>
          <.button phx-disable-with="Saving..." phx-type="submit">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{book: book} = assigns, socket) do
    form = Books.change_book(book)

    socket =
      socket
      |> assign(assigns)
      |> assign_form(form)

    {:ok, assign_form(socket, form)}
  end

  defp save_book(socket, book_params, :new) do
    book = Books.create_book(book_params)

    case book do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}

      {:ok, book} ->
        notify_parent({:saved, book})

        {
          :noreply,
          socket
          |> put_flash(:info, "Book successfully created")
          |> push_patch(to: socket.assigns.patch)
        }
    end
  end

  defp save_book(socket, book_params, :edit) do
    case Books.update_book(socket.assigns.book, book_params) do
      {:ok, new_book} ->
        notify_parent({:saved, new_book})

        {
          :noreply,
          socket
          |> put_flash(:info, "Book successfully updated")
          |> push_patch(to: socket.assigns.patch)
        }

      {:err, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("save", %{"book" => book_params}, socket) do
    save_book(socket, book_params, socket.assigns.action)
  end

  def handle_event("validate", %{"book" => book_params}, socket) do
    form =
      socket.assigns.book
      |> Books.change_book(book_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, form)}
  end

  defp assign_form(socket, form) do
    assign(socket, :form, to_form(form))
  end

  defp notify_parent(msg) do
    send(self(), {__MODULE__, msg})
  end
end
