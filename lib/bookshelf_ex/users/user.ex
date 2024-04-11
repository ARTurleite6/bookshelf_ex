defmodule BookshelfEx.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BookshelfEx.Repo

  schema "accounts" do
    field :first_name, :string
    field :last_name, :string
    field :is_admin, :boolean, default: false

    has_many :reservations, BookshelfEx.Reservations.Reservation
    has_one :active_reservation, BookshelfEx.Reservations.Reservation, where: [returned_on: nil]
    has_one :active_reading, through: [:active_reservation, :book]

    belongs_to :user, BookshelfEx.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :is_admin])
    |> validate_required([:first_name, :last_name, :is_admin])
  end

  def actively_reading?(%__MODULE__{} = user) do
    !is_nil(user |> Repo.preload(:active_reading) |> Map.get(:active_reading))
  end

  def full_name(%__MODULE__{} = user) do
    "#{user.first_name} #{user.last_name}"
  end
end
