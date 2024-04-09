defmodule BookshelfEx.BooksTest do
  alias BookshelfEx.Users.User
  use BookshelfEx.DataCase

  import BookshelfEx.Factory

  describe "list_books/0" do
    test "returns all books ordered by inserted_at" do
      # Given
      book1 = insert(:book)

      book2 =
        insert(:book)

      book3 =
        insert(:book)

      # When
      books = BookshelfEx.Books.list_books()

      # Then
      assert [book1, book2, book3] == books
    end
  end

  describe "reserve_book/2" do
    test "inserts a reservation with a given user and book" do
      user = insert(:user)
      book = insert(:book)

      assert {:ok, _} = BookshelfEx.Books.reserve_book(book, user)
    end

    test "doesn't insert a book when user already reserved another book" do
      user = insert(:user)
      reserved_book = insert(:book)
      reservation = insert(:reservation, user: user, book: reserved_book)

      book = insert(:book)
      assert {:error, _} = BookshelfEx.Books.reserve_book(book, user)
    end
  end
end
