defmodule Dimelo.SentenceTest do
  use Dimelo.DataCase
  alias Ecto.Changeset
  alias Dimelo.{Sentence, Language}

  test "text is unique, regardless of punctuation or capitalization", %{} do
    {:ok, lang} = Language.new(%{code: "en", name_eng: "English", name_sp: "Inglés"})

    data = %{
      text: "This is an english sentence!",
      language: lang
    }

    assert {:ok, %Sentence{}} = Sentence.new(data)

    assert {:error,
            %Changeset{
              valid?: false,
              errors: [text_standardized: {"" <> _, [{:constraint, :unique} | _]}]
            }} = Sentence.new(%{text: "this is an english sentence", language: lang})
  end

  describe "&standardize_text/1" do
    test "removes punctuation" do
      assert Sentence.standardize_text("!@#$%^&*()_-+=\|}]{[<,>.?/") == ""
    end
  end
end
