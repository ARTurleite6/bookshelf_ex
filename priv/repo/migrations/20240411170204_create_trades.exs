defmodule BookshelfEx.Repo.Migrations.CreateTrades do
  use Ecto.Migration

  def change do
    create table(:trades) do
      add :receiving_reservation_id, references(:reservations, on_delete: :nothing), null: false
      add :sending_reservation_id, references(:reservations, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:trades, [:receiving_reservation_id])
    create index(:trades, [:sending_reservation_id])

    create unique_index(:trades, [:receiving_reservation_id, :sending_reservation_id])
  end
end
