defmodule BookshelfEx.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string, null: false
      add :description, :text, null: false
      add :cover_url, :string, null: false
      add :genre, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end
  end
end
