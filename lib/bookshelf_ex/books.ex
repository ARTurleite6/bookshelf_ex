defmodule BookshelfEx.Books do
  import Ecto.Query

  alias BookshelfEx.{Books.Book, Repo, Reservations.Reservation, Users}

  def list_books do
    Repo.all(from b in Book, order_by: [asc: b.inserted_at])
  end

  def get_book!(id, opts \\ []) do
    preloads = Keyword.get(opts, :assocs, [])

    Repo.get!(Book, id) |> Repo.preload(preloads)
  end

  def create_book(attrs) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  def reserve_book(%Book{} = book, %Users.User{} = user) do
    Repo.transaction(fn ->
      update_book(book, %{office: user.office})

      %Reservation{}
      |> Reservation.changeset(%{book_id: book.id, user_id: user.id})
      |> Repo.insert!()
    end)
  end

  def reserve_book!(%Book{} = book, %Users.User{} = user) do
    %Reservation{}
    |> Reservation.changeset(%{book_id: book.id, user_id: user.id})
    |> Repo.insert!()
  end

  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  def delete_book!(%Book{} = book) do
    Repo.delete!(book)
  end

  def change_book(%Book{} = book, attrs \\ %{}) do
    book
    |> Book.changeset(attrs)
  end
end
