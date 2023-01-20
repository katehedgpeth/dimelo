defmodule Dimelo.Repo.Migrations.CreateSentences do
  use Ecto.Migration

  def change do
    create table(:sentences) do
      add :english, :string
      add :spanish, :string

      timestamps()
    end
  end
end
