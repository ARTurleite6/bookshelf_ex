defmodule BookshelfEx.Factory do
  use ExMachina.Ecto, repo: BookshelfEx.Repo
  alias BookshelfEx.Notifications.NotificationRequest
  alias BookshelfEx.Accounts
  alias BookshelfEx.Users.User
  alias BookshelfEx.Books.Book
  alias BookshelfEx.Reservations.Reservation

  def book_factory do
    %Book{
      title: Faker.Person.title(),
      description: Faker.Lorem.sentence(),
      cover_url: Faker.Internet.url(),
      genre: :elixir
    }
  end

  def reservation_factory do
    %Reservation{
      book: build(:book),
      user: build(:account).account,
      returned_on: nil
    }
  end

  def notification_request_factory do
    %NotificationRequest{
      user: build(:account),
      reservation: build(:reservation)
    }
  end

  def user_factory do
    %User{
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      is_admin: false
    }
  end

  def account_factory do
    %Accounts.User{
      email: Faker.Internet.email(),
      password: "password",
      hashed_password: "askdjfsdklfj",
      account: build(:user)
    }
  end
end
