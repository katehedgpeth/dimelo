defmodule Dimelo.Sentence do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Dimelo.{Sentence, Translation, Language, Repo}

  @derive {
    Jason.Encoder,
    only: [
      :id,
      :language,
      :text_punctuated,
      :translations
    ]
  }

  @punctuation "!@#$%^&*()_-+=\|}]{[<,>.?¿¡/"
               |> String.split("")
               |> Enum.reject(&(&1 == ""))

  @type t :: %__MODULE__{
          language_id: integer(),
          text_punctuated: String.t(),
          text_standardized: String.t(),
          translations: [Map.t()] | nil
        }

  schema "sentences" do
    belongs_to :language, Language
    field :text_punctuated, :string
    field :text_standardized, :string

    many_to_many :translations, Sentence,
      join_through: Translation,
      join_keys: [original_id: :id, translated_id: :id]

    many_to_many :reverse_translations, Sentence,
      join_through: Translation,
      join_keys: [translated_id: :id, original_id: :id]

    timestamps()
  end

  @doc false
  @spec changeset(%{text: String.t(), language_id: integer()}) :: Changeset.t()
  def changeset(%{text: "" <> _, language_id: language_id} = attrs)
      when is_integer(language_id) do
    {text, attrs} = Map.pop!(attrs, :text)

    %__MODULE__{}
    |> cast(
      Map.merge(attrs, %{text_punctuated: text, text_standardized: standardize_text(text)}),
      [:text_punctuated, :text_standardized, :language_id]
    )
    |> validate_required([:text_punctuated, :text_standardized, :language_id])
    |> unique_constraint(:text_standardized)
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
      translations: from(s in __MODULE__, select: s.text_standardized)
    )
  end

  def standardize_text("" <> text) do
    text
    |> String.trim()
    |> String.downcase()
    |> String.replace(@punctuation, "")
    |> String.replace("á", "a")
    |> String.replace("é", "e")
    |> String.replace("í", "i")
    |> String.replace("ó", "o")
    |> String.replace("ú", "u")
  end
end
