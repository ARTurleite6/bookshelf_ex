defmodule BookshelfEx.Books.Book do
  alias BookshelfEx.Repo
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

    field :office, Ecto.Enum,
      values: [
        :coimbra,
        :braga
      ],
      default: :coimbra

    has_many :reservations, BookshelfEx.Reservations.Reservation
    has_one :active_reservation, BookshelfEx.Reservations.Reservation, where: [returned_on: nil]
    has_one :active_reader, through: [:active_reservation, :user]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :description, :cover_url, :genre, :office])
    |> validate_required([:title, :description, :cover_url, :genre])
  end

  def reserved?(%BookshelfEx.Books.Book{} = book) do
    !(Repo.preload(book, :active_reservation).active_reservation |> is_nil())
  end

  def available?(%BookshelfEx.Books.Book{} = book) do
    !reserved?(book)
  end
end
