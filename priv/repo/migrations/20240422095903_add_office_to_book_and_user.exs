defmodule BookshelfEx.Repo.Migrations.AddOfficeToBookAndUser do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :office, :string, null: false, default: "coimbra"
    end

    alter table(:books) do
      add :office, :string, null: false, default: "coimbra"
    end
  end
end
