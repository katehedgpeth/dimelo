defmodule Dimelo.Seeder do
  alias Dimelo.{Language, Sentence, Translation, Repo}
  alias Ecto.Changeset

  @type sentence_seed :: %{english: String.t(), spanish: String.t()}

  @sentences [
    %{
      english: "It discusses your situation, and also gives you an escape.",
      spanish: "Se analiza su situación, y también le da un escape."
    },
    %{
      english: "A few hours floating on a raft in the Caribbean.",
      spanish: "Unas horas flotando en una balsa en el Caribe."
    },
    %{
      english: "Add a title naming the trip covered on each sheet.",
      spanish: "Agregar un título nombrando el viaje cubierto en cada hoja."
    }
  ]

  @spec seed(List.t(sentence_seed())) :: :ok
  def seed(sentences \\ @sentences) do
    {:ok, languages} = seed_languages()

    Enum.each(
      sentences,
      &seed_sentence(&1, languages)
    )
  end

  defp get_or_create_language(data) do
    case Language.new(data) do
      {:error, _} ->
        {:ok, Repo.get_by!(Language, code: data.code)}

      {:ok, %Language{} = lang} ->
        {:ok, lang}
    end
  end

  def seed_languages do
    {:ok, english_lang} =
      get_or_create_language(%{code: "en", name_eng: "English", name_sp: "Inglés"})

    {:ok, spanish_lang} =
      get_or_create_language(%{code: "sp", name_eng: "Spanish", name_sp: "Español"})

    {:ok, english_lang: english_lang, spanish_lang: spanish_lang}
  end

  @spec seed_sentence(sentence_seed(), [
          {:english_lang, Language.t()},
          {:spanish_lang, Language.t()}
        ]) ::
          {:ok, Translation.t()} | {:error, Changeset.t()}
  def seed_sentence(%{english: english_text, spanish: spanish_text},
        english_lang: english_lang,
        spanish_lang: spanish_lang
      ) do
    english = Sentence.new(%{text: english_text, language: english_lang})
    spanish = Sentence.new(%{text: spanish_text, language: spanish_lang})

    case {english, spanish} do
      {{:ok, english_sent}, {:ok, spanish_sent}} ->
        Translation.new(%{original: english_sent, translated: spanish_sent})

      {{:ok, english_sent}, {:error, _}} ->
        spanish_sent = Repo.get_by!(Sentence, text: spanish_text)
        Translation.new(%{original: english_sent, translated: spanish_sent})

      {{:error, _}, {:ok, spanish_sent}} ->
        english_sent = Repo.get_by!(Sentence, text: english_text)
        Translation.new(%{original: english_sent, translated: spanish_sent})

      {{:error, _}, {:error, _}} ->
        english_sent = Repo.get_by!(Sentence, text: english_text)
        spanish_sent = Repo.get_by!(Sentence, text: spanish_text)

        case Repo.get_by(Translation,
               original_id: english_sent.id,
               translated_id: spanish_sent.id
             ) do
          nil ->
            Translation.new(%{original: english_sent, translated: spanish_sent})

          %Translation{} = translation ->
            {:ok, translation}
        end

        {:ok}
    end
  end
end
