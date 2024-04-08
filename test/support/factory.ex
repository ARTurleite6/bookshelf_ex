defmodule BookshelfEx.Factory do
  use ExMachina.Ecto, repo: BookshelfEx.Repo
  alias BookshelfEx.Books.Book

  def book_factory do
    %Book{
      title: Faker.Person.title(),
      description: Faker.Lorem.sentence(),
      cover_url: Faker.Internet.url(),
      genre: :elixir
    }
  end
end
