defmodule BookshelfEx.BooksTest do
  alias BookshelfEx.Users.User
  alias BookshelfEx.Books
  use BookshelfEx.DataCase

  import BookshelfEx.Factory

  @valid_attrs %{
    title: "A Game of Thrones",
    cover_url:
      "https://images-na.ssl-images-amazon.com/images/I/51bCJ9UqK-L._SX331_BO1,204,203,200_.jpg",
    description: "akdjfskljf",
    genre: "software_engineering"
  }

  @invalid_attrs %{
    title: "",
    cover_url: "",
    description: "",
    genre: ""
  }

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
      user = insert(:account)
      book = insert(:book)

      assert {:ok, _} = BookshelfEx.Books.reserve_book(book, user.account)
    end

    test "doesn't insert a book when user already reserved another book" do
      user = insert(:account)
      reserved_book = insert(:book)
      reservation = insert(:reservation, user: user.account, book: reserved_book)

      book = insert(:book)
      assert {:error, _} = BookshelfEx.Books.reserve_book(book, user.account)
    end
  end

  describe "create_book/1" do
    test "inserts a book with valid params" do
      assert {:ok, _} = BookshelfEx.Books.create_book(@valid_attrs)
    end

    test "doesnt insert a book with invalid params" do
      assert {:error, _} = BookshelfEx.Books.create_book(@invalid_attrs)
    end
  end

  describe "update_book/2" do
    test "updates a book with valid params" do
      params = params_for(:book)
      book = insert(:book)
      assert {:ok, _} = Books.update_book(book, params)
    end

    test "gives error when updating book with invalid params" do
      invalid_params = %{title: ""}
      book = insert(:book)
      assert {:error, changeset} = Books.update_book(book, invalid_params)

      assert errors_on(changeset).title == ["can't be blank"]
    end
  end
end
