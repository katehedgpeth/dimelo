defmodule Dimelo.Repo.Migrations.UpdateSentenceColumns do
  use Ecto.Migration

  def change do
    alter table(:sentences) do
      remove :english, :string
      remove :spanish, :string
      add :language_id, references(:languages, on_delete: :nothing)
      add :text, :string
    end

    create unique_index(:sentences, :text)
  end
end
