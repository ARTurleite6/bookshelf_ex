defmodule BookshelfEx.Repo.Migrations.CreateNotificationRequests do
  use Ecto.Migration

  def change do
    create table(:notification_requests) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :reservation_id, references(:reservations, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:notification_requests, [:user_id])
    create index(:notification_requests, [:reservation_id])

    create unique_index(:notification_requests, [:user_id, :reservation_id])
  end
end
