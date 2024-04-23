defmodule BookshelfEx.Services.ReserveBookService do
  alias BookshelfEx.Accounts
  alias BookshelfEx.Mailer
  alias BookshelfEx.Users
  alias BookshelfEx.Books
  alias BookshelfEx.Books.Book
  alias BookshelfEx.Mailers.AdminMailer

  def reserve_book(%Book{} = book, %Accounts.User{} = user) do
    result = Books.reserve_book(book, user.account)

    admins = Users.list_admins()

    case result do
      {:ok, %{reservation: reservation}} ->
        for admin <- admins do
          AdminMailer.new_reservation_email(reservation, admin)
        end
        |> Mailer.deliver_many()

        {:ok, reservation}

      {:error, _, _, _} ->
        {:error, "Error reserving the book"}
    end
  end
end
