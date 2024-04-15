defmodule BookshelfEx.Repo.Migrations.AddAvailableFieldToTrade do
  use Ecto.Migration

  def change do
    alter table(:trades) do
      add :available, :boolean, null: false, default: true
    end
  end
end
