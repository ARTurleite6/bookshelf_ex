defmodule BookshelfExWeb.BooksLive.IndexLiveTest do
  use BookshelfExWeb.ConnCase

  import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  import BookshelfEx.{AccountsFixtures, Factory}

  describe "Books page" do
    test "mount the page if user is logged int", %{conn: conn} do
      book = insert(:book)
      conn = log_in_user(conn, user_fixture())
      {:ok, _live, html} = live(conn, ~p"/books")
      assert html =~ book.title
    end

    test "clicking on the book title redirects to show live view", %{conn: conn} do
      book = insert(:book)
      conn = log_in_user(conn, user_fixture())
      {:ok, view, _html} = live(conn, ~p"/books")

      assert view
             |> element("a#books-#{book.id}-redirect")
             |> render_click()
             |> follow_redirect(conn, ~p"/books/#{book.id}")
    end

    test "clicking edit activates modal", %{conn: conn} do
      book = insert(:book)
      conn = log_in_user(conn, user_fixture())
      {:ok, view, _html} = live(conn, ~p"/books")

      assert view
             |> element("a#books-#{book.id}")
             |> render_click() =~ "Title"

      assert view
             |> element("#book-modal")
             |> has_element?()
    end

    test "redirect if user is not logged in", %{conn: conn} do
      result =
        conn
        |> live(~p"/books")
        |> follow_redirect(conn, ~p"/users/log_in")

      assert {:ok, _conn} = result
    end
  end
end
