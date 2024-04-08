defmodule BookshelfEx.BooksTest do
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
end
