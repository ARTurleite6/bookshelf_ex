defmodule BookshelfEx.Books do
  alias BookshelfEx.Repo
  alias BookshelfEx.Books.Book

  def list_books do
    Repo.all(Book)
  end

  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  def get_book_preload!(id) do
    Repo.get!(Book, id) |> Repo.preload([:active_reservation, :active_reader])
  end

  def get_book_preload(id),
    do: Repo.get(Book, id) |> Repo.preload([:active_reservation, :active_reader])
end
