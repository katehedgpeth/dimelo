defmodule Dimelo.Repo.Migrations.SentenceRenameTextColumn do
  use Ecto.Migration

  def change do
    alter table(:sentences) do
      add :text_standardized, :string
    end

    drop unique_index(:sentences, :text, name: :sentences_text_index)
    rename table(:sentences), :text, to: :text_punctuated
    create unique_index(:sentences, :text_standardized)
  end
end
