defmodule Dimelo.Sentence do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sentences" do
    field :english, :string
    field :spanish, :string

    timestamps()
  end

  @doc false
  def changeset(sentence, attrs) do
    sentence
    |> cast(attrs, [:english, :spanish])
    |> validate_required([:english, :spanish])
  end
end
