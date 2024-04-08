defmodule BookshelfEx.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :description, :string
    field :title, :string
    field :cover_url, :string

    field :genre, Ecto.Enum,
      values: [
        :software_engineering,
        :design,
        :project_management,
        :ruby,
        :rails,
        :elixir,
        :phoenix,
        :android,
        :ios,
        :finance,
        :productivity
      ]

    has_many :reservations, BookshelfEx.Reservations.Reservation
    has_one :active_reservation, BookshelfEx.Reservations.Reservation, where: [returned_on: nil]
    has_one :active_reader, through: [:active_reservation, :user]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :description, :cover_url, :genre])
    |> validate_required([:title, :description, :cover_url, :genre])
  end

  def reserved?(book = %BookshelfEx.Books.Book{}) do
    book.active_reservation != nil
  end

  def available?(book = %BookshelfEx.Books.Book{}) do
    !reserved?(book)
  end
end
