defmodule BookshelfEx.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :returned_on, :date
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :book_id, references(:books, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:reservations, [:user_id])
    create index(:reservations, [:book_id])
  end
end
