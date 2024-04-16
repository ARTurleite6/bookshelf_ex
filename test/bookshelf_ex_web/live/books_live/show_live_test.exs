defmodule BookshelfExWeb.BooksLive.ShowLiveTest do
  use BookshelfExWeb.ConnCase

  import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  import BookshelfEx.{AccountsFixtures, Factory}
  alias BookshelfEx.Books
  alias BookshelfEx.Repo

  describe "Book page" do
    test "redirect if user is not logged in", %{conn: conn} do
      book = insert(:book)

      assert conn
             |> live(~p"/books/#{book.id}")
             |> follow_redirect(conn, ~p"/users/log_in")
    end

    test "renders the book page", %{conn: conn} do
      book = insert(:book)

      {:ok, _live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/books/#{book.id}")

      assert html =~ book.title
      assert html =~ book.description
    end

    test "renders the reserve book if user doesn't have any reservation and book is available", %{
      conn: conn
    } do
      book = insert(:book)

      {:ok, view, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/books/#{book.id}")

      assert view
             |> element("#reserve-book")
             |> has_element?()
    end

    test "reserves the book when reserve button is clicked", %{
      conn: conn
    } do
      book = insert(:book)

      user =
        {:ok, view, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/books/#{book.id}")

      result =
        view
        |> element("#reserve-book")
        |> render_click()

      book = Repo.reload!(book) |> Repo.preload(:active_reservation)
      assert book.active_reservation
    end
  end
end
