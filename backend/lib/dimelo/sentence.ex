defmodule Dimelo.Sentence do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Dimelo.{Sentence, Translation, Language, Repo}

  @derive {Jason.Encoder, only: [:id, :language, :text, :translations]}

  @type t :: %__MODULE__{
          language_id: integer(),
          text: String.t(),
          translations: [Map.t()] | nil
        }

  schema "sentences" do
    belongs_to :language, Language
    field :text, :string

    many_to_many :translations, Sentence,
      join_through: Translation,
      join_keys: [original_id: :id, translated_id: :id]

    many_to_many :reverse_translations, Sentence,
      join_through: Translation,
      join_keys: [translated_id: :id, original_id: :id]

    timestamps()
  end

  @doc false
  def changeset(sentence \\ %__MODULE__{}, attrs) do
    sentence
    |> cast(attrs, [:text, :language_id])
    |> validate_required([:text, :language_id])
    |> unique_constraint(:text)
  end

  def new(%{text: "" <> _, language: %Language{id: lang_id}} = data) do
    data
    |> Map.delete(:language)
    |> Map.put(:language_id, lang_id)
    |> changeset()
    |> Repo.insert()
  end

  def all do
    Repo.all(from(s in __MODULE__))
  end

  def serialize([]), do: []

  def serialize([%__MODULE__{} | _] = sentences) do
    sentences
    |> Repo.preload(
      language: from(l in Language, select: l.code),
      translations: from(s in __MODULE__, select: s.text)
    )
  end
end
