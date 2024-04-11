defmodule BookshelfEx.Notifications.NotificationRequest do
  alias BookshelfEx.Users
  alias BookshelfEx.Accounts
  alias BookshelfEx.Reservations.Reservation
  alias BookshelfEx.Reservations
  use Ecto.Schema
  import Ecto.Changeset

  schema "notification_requests" do
    belongs_to :user, BookshelfEx.Accounts.User
    belongs_to :reservation, BookshelfEx.Reservations.Reservation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(notification_request, attrs) do
    notification_request
    |> cast(attrs, [:user_id, :reservation_id])
    |> validate_required([:user_id, :reservation_id])
    |> unique_constraint([:user_id, :reservation_id])
    |> validate_user_cannot_be_the_same_as_reservation_owner()
  end

  def validate_user_cannot_be_the_same_as_reservation_owner(changeset) do
    user_id = get_field(changeset, :user_id)
    reservation_id = get_field(changeset, :reservation_id)

    %Accounts.User{account: %Users.User{id: account_id}} =
      Accounts.get_user!(user_id) |> Accounts.with_assoc(:account)

    %Reservation{user_id: owner_id} = Reservations.get_reservation!(reservation_id)

    if owner_id == account_id do
      add_error(changeset, :user_id, "can't be the same as the reservation owner")
    else
      changeset
    end
  end
end
