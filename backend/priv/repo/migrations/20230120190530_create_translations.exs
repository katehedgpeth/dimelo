defmodule Dimelo.Repo.Migrations.CreateTranslations do
  use Ecto.Migration

  def change do
    create table(:translations, primary_key: false) do
      add :original_id, references(:sentences, on_delete: :nothing)
      add :translated_id, references(:sentences, on_delete: :nothing)

      timestamps()
    end

    create index(:translations, [:original_id])
    create index(:translations, [:translated_id])

    create unique_index(
             :translations,
             [:original_id, :translated_id],
             name: :translations_original_to_translated_index
           )

    create unique_index(
             :translations,
             [:translated_id, :original_id],
             name: :translations_tranlated_to_original_index
           )
  end
end
