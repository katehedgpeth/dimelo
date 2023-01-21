defmodule Dimelo.SentenceTest do
  use Dimelo.DataCase
  alias Ecto.Changeset
  alias Dimelo.{Sentence, Language}

  test "text column is unique", %{} do
    {:ok, lang} = Language.new(%{code: "en", name_eng: "English", name_sp: "Inglés"})

    data = %{
      text: "this is an english sentence",
      language: lang
    }

    assert {:ok, %Sentence{}} = Sentence.new(data)

    assert {:error,
            %Changeset{valid?: false, errors: [text: {"" <> _, [{:constraint, :unique} | _]}]}} =
             Sentence.new(data)
  end
end
