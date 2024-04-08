defmodule BookshelfEx.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :user_id, references(:accounts, on_delete: :delete_all), null: false
      add :book_id, references(:books, on_delete: :delete_all), null: false

      add :returned_on, :date

      timestamps(type: :utc_datetime)
    end

    create index(:reservations, [:user_id])
    create index(:reservations, [:book_id])
  end
end
