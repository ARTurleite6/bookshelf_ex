defmodule BookshelfEx.Books.Book do
  require Ecto.Query
  alias BookshelfEx.Reservations.Reservation
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :description, :string
    field :title, :string
    field :cover_url, :string

    has_many :reservations, Reservation
    has_one :active_reservation, Reservation, where: [returned_on: nil]
    has_one :active_reader, through: [:active_reservation, :user]

    field :genre, Ecto.Enum,
      values: [
        software_engineering: 0,
        fantasy: 1,
        mystery: 2,
        scifi: 3,
        romance: 4,
        horror: 5,
        nonfiction: 6
      ],
      default: :software_engineering

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :description, :cover_url, :genre])
    |> validate_required([:title, :description, :cover_url, :genre])
  end
end
