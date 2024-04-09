defmodule BookshelfEx.Factory do
  use ExMachina.Ecto, repo: BookshelfEx.Repo
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
      user: build(:user)
    }
  end

  def user_factory do
    %User{
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      user: build(:account)
    }
  end

  def account_factory do
    %Accounts.User{
      email: Faker.Internet.email(),
      password: "password",
      hashed_password: "askdjfsdklfj"
    }
  end
end
