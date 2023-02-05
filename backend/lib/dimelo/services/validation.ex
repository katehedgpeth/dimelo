defmodule Dimelo.Services.Validation do
  alias Dimelo.Translation
  alias Dimelo.{Language, Sentence, Repo, Services.OpenAI}

  @spec validate(Sentence.t(), String.t()) ::
          boolean
          | {:error, HTTPoison.Response.t()}
          | {:error, HTTPoison.Error.t()}
  def validate(%Sentence{} = prompt, "" <> translation) do
    standardized = Sentence.standardize_text(translation)

    case OpenAI.fetch_translations(prompt) do
      [_ | _] = translations ->
        %Language{} = spanish = Repo.get_by(Language, code: "sp")
        Enum.each(translations, &save_translation(spanish, spanish: &1, english: prompt))
        Enum.any?(translations, &is_a_match?(&1, standardized))

      {:error, error} ->
        {:error, error}
    end
  end

  defp save_translation(
         %Language{code: "sp"} = spanish_lang,
         spanish: spanish_text,
         english: %Sentence{} = english
       ) do
    {:ok, %Sentence{} = sentence} =
      Sentence.get_or_create(%{text: spanish_text, language: spanish_lang})

    Translation.get_or_create(%{original: english, translated: sentence})
  end

  defp is_a_match?(raw_ai, standardized_human),
    do: Sentence.standardize_text(raw_ai) == standardized_human
end
