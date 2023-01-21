defmodule Dimelo.TranslationTest do
  use Dimelo.DataCase
  alias Dimelo.{Repo, Language, Translation, Sentence}
  alias Ecto.Changeset

  setup do
    Dimelo.Seeder.seed([])

    [%Language{code: "en"} = english_lang, %Language{code: "sp"} = spanish_lang] =
      Repo.all(Language)

    {:ok, english} =
      Sentence.new(%{text: "This is a sentence in English", language: english_lang})

    {:ok, spanish} = Sentence.new(%{text: "Esta es una frase en Español", language: spanish_lang})

    {:ok, english: english, spanish: spanish, english_lang: english_lang}
  end

  describe "&new/1" do
    test "adds a translation if it doesn't exist", %{english: english, spanish: spanish} do
      %{id: english_id} = english
      %{id: spanish_id} = spanish

      assert {:ok, %Translation{original_id: ^english_id, translated_id: ^spanish_id}} =
               Translation.new(%{original: english, translated: spanish})

      english = Repo.preload(english, [:translations, :reverse_translations])
      assert english.translations == [spanish]
      assert english.reverse_translations == english.translations
      spanish = Repo.preload(spanish, [:translations, :reverse_translations])
      assert [%{id: ^english_id}] = spanish.translations
      assert spanish.reverse_translations == spanish.translations
    end

    test "returns :error if translation already exists", %{english: english, spanish: spanish} do
      data = %{original: english, translated: spanish}
      assert {:ok, _} = Translation.new(data)

      assert {:error,
              %Changeset{
                valid?: false,
                errors: [original_id: {_, [{:constraint, :unique} | _]}]
              }} = Translation.new(%{original: english, translated: spanish})

      assert {:error,
              %Changeset{
                valid?: false,
                errors: [original_id: {_, [{:constraint, :unique} | _]}]
              }} = Translation.new(%{original: spanish, translated: english})
    end

    test "can take multiple translations", %{
      spanish: spanish,
      english: english_1,
      english_lang: english_lang
    } do
      assert {:ok, %Translation{}} = Translation.new(%{original: spanish, translated: english_1})
      {:ok, english_2} = Sentence.new(%{text: "This is a Spanish phrase", language: english_lang})

      assert {:ok, %Translation{}} = Translation.new(%{original: spanish, translated: english_2})

      assert %Sentence{translations: [^english_1, ^english_2]} =
               Repo.preload(spanish, :translations)

      assert %Sentence{translations: [^spanish]} = Repo.preload(english_1, :translations)
      assert %Sentence{translations: [^spanish]} = Repo.preload(english_2, :translations)
    end
  end
end
