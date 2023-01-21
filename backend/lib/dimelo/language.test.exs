defmodule Dimelo.LanguageTest do
  use Dimelo.DataCase
  alias Dimelo.{Language, Repo, Sentence}
  alias Ecto.Changeset

  @spanish %{code: "sp", name_eng: "Spanish", name_sp: "Español"}

  test "code, name_eng, and name_sp are unique" do
    assert {:ok, %Language{id: id}} = Language.new(@spanish)
    assert %Language{} = Repo.get(Language, id)

    assert {:error,
            %Changeset{
              errors: [
                code:
                  {"has already been taken",
                   constraint: :unique, constraint_name: "languages_code_index"}
              ]
            }} = Language.new(@spanish)

    assert {:error,
            %Changeset{
              errors: [
                name_sp:
                  {"has already been taken",
                   constraint: :unique, constraint_name: "languages_name_sp_index"}
              ]
            }} = Language.new(%{@spanish | code: "sp2"})

    assert {:error,
            %Changeset{
              errors: [
                name_eng:
                  {"has already been taken",
                   constraint: :unique, constraint_name: "languages_name_eng_index"}
              ]
            }} = Language.new(%{@spanish | code: "sp2", name_sp: "Espanol"})
  end

  describe "&sentences/1" do
    test "returns a list of sentences in that language" do
      assert {:ok, spanish} = Language.new(@spanish)

      assert {:ok, %Sentence{} = sentence} =
               Sentence.new(%{language: spanish, text: "This is a sentence"})

      assert Language.sentences(@spanish.code) == [sentence]
    end
  end
end
