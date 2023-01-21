defmodule Dimelo.Repo.Migrations.CreateLanguages do
  use Ecto.Migration

  def change do
    create table(:languages) do
      add :code, :string
      add :name_eng, :string
      add :name_sp, :string

      timestamps()
    end

    create unique_index(:languages, [:code])
    create unique_index(:languages, [:name_sp])
    create unique_index(:languages, [:name_eng])
  end
end
