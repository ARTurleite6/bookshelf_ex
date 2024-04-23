defmodule BookshelfEx.Repo.Migrations.ChangeAvailabilityFieldToStatusTrades do
  use Ecto.Migration

  def change do
    rename table(:trades), :available, to: :status

    alter table(:trades) do
      modify :status, :string, null: false, default: "pending"
    end
  end
end
